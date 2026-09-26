local api = vim.api
local redraw = api.nvim__redraw
local diagnostic = vim.diagnostic
local lsp = vim.lsp
local schedule = vim.schedule
local next = next

local basename
local dirname
do
  local fs = vim.fs
  basename = fs.basename
  dirname = fs.dirname
end

local statusline = "%{%get(b:, 'ferry_statusline', '')%}"
local buffers = {}
local redraw_pending = {}

local function highlight(group, value)
  return "%#" .. group .. "#" .. value .. "%*"
end

local function request_redraw(bufnr)
  if redraw_pending[bufnr] then
    return
  end

  redraw_pending[bufnr] = true

  schedule(function()
    redraw_pending[bufnr] = nil

    if api.nvim_buf_is_valid(bufnr) then
      redraw({ buf = bufnr, statusline = true })
    end
  end)
end

local function refresh(buffer)
  local value = buffer.file
    .. " "
    .. buffer.progress
    .. " "
    .. buffer.git
    .. "%="
    .. buffer.lsp
    .. " ("
    .. "%{toupper(strpart(&ft, 0, 1)) . strpart(&ft, 1)}"
    .. (buffer.diagnostics ~= "" and " " .. buffer.diagnostics or "")
    .. ")"
    .. " "
    .. "%P (L%-3l, C%-2c)"

  if value == buffer.statusline then
    return
  end

  buffer.statusline = value
  vim.b[buffer.bufnr].ferry_statusline = value
  request_redraw(buffer.bufnr)
end

local function update_buffer(bufnr, update, ...)
  local buffer = buffers[bufnr]

  if not buffer then
    return
  end

  update(buffer, ...)
  refresh(buffer)
end

local update_diagnostics
do
  local severity = diagnostic.severity

  local function render(diagnostics)
    local errors, warnings, infos = 0, 0, 0

    for _, item in next, diagnostics do
      if item.severity == severity.ERROR then
        errors = errors + 1
      elseif item.severity == severity.WARN then
        warnings = warnings + 1
      elseif item.severity == severity.INFO then
        infos = infos + 1
      end
    end

    return "["
      .. highlight("DiagnosticError", errors)
      .. " "
      .. highlight("DiagnosticWarn", warnings)
      .. " "
      .. highlight("DiagnosticInfo", infos)
      .. "]"
  end

  update_diagnostics = function(buffer, diagnostics)
    local bufnr = buffer.bufnr

    if
      not diagnostic.is_enabled({ bufnr = bufnr })
      or not next(lsp.get_clients({ bufnr = bufnr }))
    then
      buffer.diagnostics = ""
      return
    end

    buffer.diagnostics = render(diagnostics)
  end
end

local update_file
do
  local bo = vim.bo
  local o = vim.o
  local format = string.format
  local encoding = {
    [""] = "U",
    ["utf-8"] = "U",
    ["latin1"] = "1",
  }
  local fileformat = {
    unix = ":",
    dos = "\\",
    mac = "/",
  }

  local function render(options, name)
    local path = name == "" and "[No Name]"
      or format("%s/%s", basename(dirname(name)), basename(name))
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
    buffer.file = render(bo[buffer.bufnr], api.nvim_buf_get_name(buffer.bufnr))
  end
end

local update_git
local stop_git
do
  local schedule_wrap = vim.schedule_wrap
  local system = vim.system
  local trim = vim.trim

  local function render(head, added, changed, removed)
    if head == "" and added == 0 and changed == 0 and removed == 0 then
      return ""
    end

    return (head ~= "" and highlight("GitHead", "Git:" .. head) or "")
      .. (added > 0 and " " .. highlight("GitAdd", "+" .. added) or "")
      .. (changed > 0 and " " .. highlight("GitChange", "~" .. changed) or "")
      .. (removed > 0 and " " .. highlight("GitDelete", "-" .. removed) or "")
  end

  local function diffstat(stdout)
    local added, changed, removed = 0, 0, 0
    local from = 1

    while true do
      local _, finish, old, new = stdout:find("@@ %-%d+,?(%d*) %+%d+,?(%d*)", from)

      if not finish then
        return added, changed, removed
      end

      old = old ~= "" and old * 1 or 1
      new = new ~= "" and new * 1 or 1

      local common = old < new and old or new

      changed = changed + common
      added = added + new - common
      removed = removed + old - common

      from = finish + 1
    end
  end

  stop_git = function(buffer)
    local process = buffer.git_process

    if not process then
      return
    end

    buffer.git_process = nil
    process:kill("sigterm")
  end

  local function start_diff(buffer, head, name)
    local process

    process = system(
      {
        "git",
        "-C",
        dirname(name),
        "diff",
        "-U0",
        "--no-color",
        "--no-ext-diff",
        "--",
        name,
      },
      {
        text = true,
        stderr = false,
      },
      schedule_wrap(function(result)
        if buffer.git_process ~= process then
          return
        end

        buffer.git_process = nil

        if result.code == 0 then
          local added, changed, removed = diffstat(result.stdout or "")
          buffer.git = render(head, added, changed, removed)
        else
          buffer.git = render(head, 0, 0, 0)
        end

        refresh(buffer)
      end)
    )

    buffer.git_process = process
  end

  local function start_head(buffer, name)
    local process
    process = system(
      {
        "git",
        "-C",
        dirname(name),
        "rev-parse",
        "--abbrev-ref",
        "HEAD",
      },
      {
        text = true,
        stderr = false,
      },
      schedule_wrap(function(result)
        if buffer.git_process ~= process then
          return
        end

        if result.code == 0 then
          start_diff(buffer, trim(result.stdout or ""), name)
        else
          buffer.git_process = nil
          buffer.git = ""
          refresh(buffer)
        end
      end)
    )

    buffer.git_process = process
  end

  local function gitsigns(bufnr)
    local value = vim.b[bufnr].gitsigns_status_dict

    if type(value) ~= "table" then
      return
    end

    return type(value.head) == "string" and value.head or "",
      type(value.added) == "number" and value.added or 0,
      type(value.changed) == "number" and value.changed or 0,
      type(value.removed) == "number" and value.removed or 0
  end

  update_git = function(buffer)
    local bufnr = buffer.bufnr
    local head, added, changed, removed = gitsigns(bufnr)

    if head ~= nil then
      stop_git(buffer)
      buffer.git = render(head, added, changed, removed)
      return
    end

    if buffer.git_process then
      return
    end

    local name = api.nvim_buf_get_name(bufnr)

    if name == "" then
      buffer.git = ""
      return
    end

    start_head(buffer, name)
  end

  for _, name in next, { "Add", "Change", "Delete" } do
    api.nvim_set_hl(0, "Git" .. name, {
      fg = api.nvim_get_hl(0, { name = "Diff" .. name }).bg,
    })
  end
end

local update_lsp
do
  local concat = table.concat
  local names = {}

  local function render(clients, detached)
    local count = 0

    for _, client in next, clients do
      if client.id ~= detached then
        count = count + 1
        names[count] = client.name
      end
    end

    if count == 0 then
      return ""
    end

    return "[" .. concat(names, ",", 1, count) .. "]"
  end

  update_lsp = function(buffer, detached)
    buffer.lsp = render(lsp.get_clients({ bufnr = buffer.bufnr }), detached)
  end
end

local update_lsp_progress
do
  local spinner = { "|", "/", "-", "\\" }

  local function render(index, args)
    local params = args.data and args.data.params
    local value = params and params.value

    if value and value.kind ~= "end" then
      index = index % #spinner + 1
      return spinner[index], index
    end

    return "", index
  end

  update_lsp_progress = function(buffer, args)
    buffer.progress, buffer.spinner = render(buffer.spinner, args)
  end
end

do
  local group = api.nvim_create_augroup("ferry.statusline", { clear = true })
  local autocmd = api.nvim_create_autocmd
  local set_option = api.nvim_set_option_value
  local win_type = vim.fn.win_gettype

  local function install(buffer)
    if win_type(0) ~= "" or api.nvim_win_get_buf(0) ~= buffer.bufnr then
      return
    end

    set_option("statusline", statusline, { win = 0 })
  end

  local function update_all(buffer)
    update_file(buffer)
    update_lsp(buffer)
    update_diagnostics(buffer, diagnostic.get(buffer.bufnr))
    update_git(buffer)
    refresh(buffer)
  end

  local function initialize(bufnr)
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
    install(buffer)
  end

  autocmd("BufDelete", {
    group = group,
    callback = function(args)
      local buf = args.buf

      stop_git(buffers[buf])
      redraw_pending[buf] = nil
      buffers[buf] = nil
    end,
  })

  autocmd({ "BufEnter", "BufFilePost", "FileType" }, {
    group = group,
    callback = function(args)
      local buffer = buffers[args.buf]

      if buffer then
        update_all(buffer)
      else
        initialize(args.buf)
      end
    end,
  })

  autocmd("BufWinEnter", {
    group = group,
    callback = function(args)
      install(buffers[args.buf])
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
      update_diagnostics(buffer, diagnostic.get(args.buf))
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
