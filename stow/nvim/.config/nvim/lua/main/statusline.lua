local api = vim.api
local autocmd = api.nvim_create_autocmd
local set_option = api.nvim_set_option_value

local bo = vim.bo
local diagnostic = vim.diagnostic
local lsp = vim.lsp
local o = vim.o
local redraw = vim.cmd.redrawstatus
local schedule = vim.schedule

local concat = table.concat
local format = string.format
local next = next

local fnamemodify
local win_type
do
  local fn = vim.fn
  fnamemodify = fn.fnamemodify
  win_type = fn.win_gettype
end

local buffers = {}

local function highlight(group, value)
  return "%#" .. group .. "#" .. tostring(value) .. "%*"
end

local refresh
local update_buffer
do
  local function compose(buffer)
    return buffer.file
      .. " "
      .. buffer.progress
      .. " "
      .. buffer.git
      .. "%=%="
      .. buffer.lsp
      .. " ("
      .. "%{toupper(strpart(&ft, 0, 1)) . strpart(&ft, 1)}"
      .. (buffer.diagnostics ~= "" and " " .. buffer.diagnostics or "")
      .. ")"
      .. "  "
      .. "%P (%{printf('L%-3d, C%-2d', line('.'), col('.'))})"
  end

  local function install(buffer)
    for _, win in next, api.nvim_list_wins() do
      if api.nvim_win_get_buf(win) == buffer.bufnr and win_type(win) == "" then
        set_option("statusline", buffer.statusline, { win = win })
      end
    end
  end

  refresh = function(buffer)
    local statusline = compose(buffer)

    if statusline == buffer.statusline then
      return
    end

    buffer.statusline = statusline

    install(buffer)
    redraw()
  end

  update_buffer = function(bufnr, update, ...)
    local buffer = buffers[bufnr]

    if not buffer or not api.nvim_buf_is_valid(bufnr) then
      return
    end

    update(buffer, ...)
    refresh(buffer)
  end
end

local update_diagnostics
do
  local diagnostic_groups = {
    "DiagnosticError",
    "DiagnosticWarn",
    "DiagnosticInfo",
  }

  local function render_diagnostics(diagnostics, enabled, has_lsp)
    if not enabled or not has_lsp then
      return ""
    end

    local counts = { 0, 0, 0 }

    for _, item in next, diagnostics do
      local severity = item.severity

      if severity and severity <= diagnostic.severity.INFO then
        counts[severity] = counts[severity] + 1
      end
    end

    local parts = {}

    for severity = diagnostic.severity.ERROR, diagnostic.severity.INFO do
      parts[severity] = highlight(diagnostic_groups[severity], counts[severity])
    end

    return "[" .. concat(parts, " ") .. "]"
  end

  update_diagnostics = function(buffer, diagnostics)
    local bufnr = buffer.bufnr

    buffer.diagnostics = render_diagnostics(
      diagnostics,
      diagnostic.is_enabled({ bufnr = bufnr }),
      next(lsp.get_clients({ bufnr = bufnr })) ~= nil
    )
  end
end

local update_file
do
  local encoding = {
    [""] = "U",
    ["utf-8"] = "U",
    ["latin1"] = "1",
  }

  local fileformat = {
    dos = "\\",
    mac = "/",
  }

  local function render_file(options, name)
    local path = name == "" and "[No Name]"
      or format("%s/%s", fnamemodify(name, ":h:t"), fnamemodify(name, ":t"))

    local flags = options.readonly and (options.modified and "%*" or "%%")
      or (options.modified and "**" or "--")

    return (encoding[options.fileencoding] or "-")
      .. (o.encoding == "utf-8" and "U" or "")
      .. (fileformat[options.fileformat] or ":")
      .. flags
      .. "-  T%{tabpagenr()} "
      .. highlight("Title", path)
  end

  update_file = function(buffer)
    local bufnr = buffer.bufnr
    buffer.file = render_file(bo[bufnr], api.nvim_buf_get_name(bufnr))
  end
end

local update_git
do
  local git_fields = {
    { "head", "GitHead", "Git:" },
    { "added", "GitAdd", "+" },
    { "changed", "GitChange", "~" },
    { "removed", "GitDelete", "-" },
  }

  local function cancel(buffer)
    local process = buffer.git_process

    if not process then
      return
    end

    process:kill("sigterm")
    buffer.git_process = nil
  end

  local function parse_git_status(bufnr)
    local ok, status = pcall(api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")

    if not ok or type(status) ~= "table" or next(status) == nil then
      return nil
    end

    return {
      head = type(status.head) == "string" and status.head ~= "" and status.head or nil,
      added = type(status.added) == "number" and status.added or 0,
      changed = type(status.changed) == "number" and status.changed or 0,
      removed = type(status.removed) == "number" and status.removed or 0,
    }
  end

  local function render_git(status)
    if not status then
      return ""
    end

    local parts = {}
    local count = 0

    for _, field in next, git_fields do
      local name = field[1]
      local value = status[name]

      if name == "head" then
        if value then
          count = count + 1
          parts[count] = highlight(field[2], field[3] .. value)
        end
      elseif value > 0 then
        count = count + 1
        parts[count] = highlight(field[2], field[3] .. value)
      end
    end

    return concat(parts, " ")
  end

  local function finish(buffer, process)
    if buffer.git_process ~= process then
      return
    end

    buffer.git_process = nil

    local status = parse_git_status(buffer.bufnr)

    if status then
      local branch = process.code == 0 and vim.trim(process.stdout or "") or nil
      status.head = branch ~= "" and branch or status.head
    end

    buffer.git = render_git(status)
    refresh(buffer)
  end

  update_git = function(buffer)
    local bufnr = buffer.bufnr
    local status = parse_git_status(bufnr)

    if not status then
      cancel(buffer)
      buffer.git = ""
      return
    end

    buffer.git = render_git(status)

    if status.head or buffer.git_process then
      return
    end

    local process
    process = vim.system(
      { "git", "config", "--get", "init.defaultBranch" },
      { text = true },
      function()
        schedule(function()
          local state = buffers[buffer.bufnr]

          if state then
            finish(state, process)
          end
        end)
      end
    )

    buffer.git_process = process
  end

  for _, name in next, { "Add", "Change", "Delete" } do
    local diff = api.nvim_get_hl(0, { name = "Diff" .. name })
    api.nvim_set_hl(0, "Git" .. name, { fg = diff.bg })
  end
end

local update_lsp
do
  local function render_lsp(clients, detached)
    local names = {}
    local count = 0

    for _, client in next, clients do
      if client.id ~= detached then
        count = count + 1
        names[count] = client.name
      end
    end

    return count > 0 and "[" .. concat(names, ",") .. "]" or ""
  end

  update_lsp = function(buffer, detached)
    buffer.lsp = render_lsp(lsp.get_clients({ bufnr = buffer.bufnr }), detached)
  end
end

local update_lsp_progress
do
  local spinner = { "|", "/", "-", "\\" }

  local function progress_text(spinner_index, args)
    local params = args.data and args.data.params
    local value = params and params.value

    if value and value.message and value.kind ~= "end" then
      spinner_index = spinner_index % #spinner + 1
      return spinner[spinner_index], spinner_index
    end

    return "", spinner_index
  end

  update_lsp_progress = function(buffer, args)
    buffer.progress, buffer.spinner = progress_text(buffer.spinner, args)
  end
end

do
  local group = api.nvim_create_augroup("ferry.statusline", {})

  local function update_all(buffer)
    update_file(buffer)
    update_lsp(buffer)
    update_diagnostics(buffer, diagnostic.get(buffer.bufnr))
    update_git(buffer)
    refresh(buffer)
  end

  local function initialize(bufnr)
    if bo[bufnr].buftype ~= "" then
      return
    end

    local buffer = {
      bufnr = bufnr,

      file = "",
      progress = "",
      git = "",
      lsp = "",
      diagnostics = "",
      statusline = "",
      spinner = 0,

      git_process = nil,
    }

    buffers[bufnr] = buffer
    update_all(buffer)
  end

  autocmd("BufDelete", {
    group = group,
    callback = function(args)
      local buffer = buffers[args.buf]
      if not buffer then
        return
      end

      if buffer.git_process then
        buffer.git_process:kill("sigterm")
      end

      buffers[args.buf] = nil
    end,
  })

  autocmd({ "BufEnter", "BufFilePost", "FileType" }, {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local buffer = buffers[bufnr]

      if buffer then
        update_all(buffer)
      else
        initialize(bufnr)
      end
    end,
  })

  autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
      local buffer = buffers[args.buf]

      if not buffer or win_type(0) ~= "" then
        return
      end

      set_option("statusline", buffer.statusline, { win = 0 })
    end,
  })

  autocmd("DiagnosticChanged", {
    group = group,
    callback = function(args)
      update_buffer(args.buf, update_diagnostics, args.data.diagnostics)
    end,
  })

  autocmd({ "LspAttach", "LspDetach" }, {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local buffer = buffers[bufnr]

      if not buffer then
        return
      end

      local detached = args.event == "LspDetach" and args.data.client_id or nil

      update_lsp(buffer, detached)
      update_diagnostics(buffer, diagnostic.get(bufnr))
      refresh(buffer)
    end,
  })

  autocmd("LspProgress", {
    group = group,
    callback = function(args)
      local client = lsp.get_client_by_id(args.data.client_id)

      if not client then
        return
      end

      for bufnr in next, client.attached_buffers do
        update_buffer(bufnr, update_lsp_progress, args)
      end
    end,
  })

  autocmd("OptionSet", {
    group = group,
    pattern = { "fileencoding", "fileformat", "modified", "readonly" },
    callback = function()
      update_buffer(api.nvim_get_current_buf(), update_file)
    end,
  })

  autocmd("User", {
    group = group,
    pattern = "GitSignsUpdate",
    callback = function(args)
      update_buffer(args.buf, update_git)
    end,
  })

  initialize(api.nvim_get_current_buf())
end
