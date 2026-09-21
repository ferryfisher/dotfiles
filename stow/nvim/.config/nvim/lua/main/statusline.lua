local api = vim.api
local autocmd = api.nvim_create_autocmd
local set_option = api.nvim_set_option_value

local diagnostic = vim.diagnostic
local lsp = vim.lsp
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

local diagnostic_groups = {
  "DiagnosticError",
  "DiagnosticWarn",
  "DiagnosticInfo",
}

local encoding = {
  [""] = "U",
  ["utf-8"] = "U",
  ["latin1"] = "1",
}

local fileformat = {
  dos = "\\",
  mac = "/",
}

local git_fields = {
  { "head", "GitHead", "Git:" },
  { "added", "GitAdd", "+" },
  { "changed", "GitChange", "~" },
  { "removed", "GitDelete", "-" },
}

local spinner = { "|", "/", "-", "\\" }

local spawn_thread
do
  local pool = {}

  local function run(thread, callback, ...)
    callback(...)
    pool[#pool + 1] = thread
  end

  local function worker()
    while true do
      run(coroutine.yield())
    end
  end

  spawn_thread = function(callback, ...)
    local n = #pool

    if n == 0 then
      local thread = coroutine.create(worker)
      coroutine.resume(thread)
      assert(coroutine.resume(thread, thread, callback, ...))
    else
      local thread = pool[n]
      pool[n] = nil
      assert(coroutine.resume(thread, thread, callback, ...))
    end
  end
end

local function highlight(group, value)
  return "%#" .. group .. "#" .. tostring(value) .. "%*"
end

local function git_status(bufnr)
  local ok, status = pcall(api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")
  return ok and status or nil
end

local function compose(buffer)
  buffer.statusline = buffer.file
    .. buffer.progress
    .. buffer.git
    .. "%=%="
    .. buffer.lsp
    .. buffer.diagnostics
    .. "  %P (%{printf('L%-3d, C%-2d', line('.'), col('.'))})"
end

local function install(bufnr)
  local statusline = buffers[bufnr].statusline

  for _, win in next, api.nvim_list_wins() do
    if api.nvim_win_get_buf(win) == bufnr and win_type(win) == "" then
      set_option("statusline", statusline, { win = win })
    end
  end
end

local function refresh(bufnr)
  compose(buffers[bufnr])
  install(bufnr)
  redraw()
end

local function update_file(buffer, bufnr)
  local options = vim.bo[bufnr]
  local name = api.nvim_buf_get_name(bufnr)

  local path = name == "" and "[No Name]"
    or format("%s/%s", fnamemodify(name, ":h:t"), fnamemodify(name, ":t"))

  local flags = options.readonly and (options.modified and "%*" or "%%")
    or (options.modified and "**" or "--")

  buffer.file = (encoding[options.fileencoding] or "-")
    .. (vim.o.encoding == "utf-8" and "U" or "")
    .. (fileformat[options.fileformat] or ":")
    .. flags
    .. "-  T"
    .. api.nvim_tabpage_get_number(0)
    .. " %#Title#"
    .. path
end

local function update_progress(buffer, args)
  local params = args.data and args.data.params
  local value = params and params.value

  if value and value.message and value.kind ~= "end" then
    buffer.spinner = buffer.spinner % #spinner + 1
    buffer.progress = " " .. spinner[buffer.spinner]
  else
    buffer.progress = ""
  end
end

local function update_lsp(buffer, bufnr, detached)
  local clients = lsp.get_clients({ bufnr = bufnr })
  local names = {}
  local count = 0

  for _, client in next, clients do
    if client.id ~= detached then
      count = count + 1
      names[count] = client.name
    end
  end

  buffer.lsp = count > 0 and " [" .. concat(names, ",") .. "]" or ""
end

local function update_diagnostics(buffer, bufnr, diagnostics)
  if not diagnostic.is_enabled({ bufnr = bufnr }) or #lsp.get_clients({ bufnr = bufnr }) == 0 then
    buffer.diagnostics = ""
    return
  end

  local counts = { 0, 0, 0 }

  for _, item in next, diagnostics do
    local severity = item.severity

    if severity and severity <= 3 then
      counts[severity] = counts[severity] + 1
    end
  end

  local parts = {}

  for severity = 1, 3 do
    parts[severity] = highlight(diagnostic_groups[severity], counts[severity])
  end

  local language = vim.bo[bufnr].filetype

  if language ~= "" then
    language = language:sub(1, 1):upper() .. language:sub(2)
    buffer.diagnostics = " (" .. language .. " [" .. concat(parts, " ") .. "])"
  else
    buffer.diagnostics = " [" .. concat(parts, " ") .. "]"
  end
end

local function update_git(buffer, bufnr, status)
  if not status or next(status) == nil then
    buffer.git = ""
    return
  end

  local parts = {}
  local count = 0

  for _, field in next, git_fields do
    local value = status[field[1]]

    if field[1] == "head" or (type(value) == "number" and value > 0) then
      count = count + 1
      parts[count] = highlight(field[2], field[3] .. value)
    end
  end

  buffer.git = " " .. concat(parts, " ")

  if status.head == "" and not buffer.git_pending then
    buffer.git_pending = true

    spawn_thread(function()
      vim.system(
        { "git", "config", "--get", "init.defaultBranch" },
        { text = true },
        function(result)
          schedule(function()
            if not api.nvim_buf_is_valid(bufnr) then
              return
            end

            buffer.git_pending = false
            status.head = #result.stdout > 0 and vim.trim(result.stdout) or nil

            update_git(buffer, bufnr, status)
            refresh(bufnr)
          end)
        end
      )
    end)
  end
end

local function update(buffer, bufnr)
  update_file(buffer, bufnr)
  update_lsp(buffer, bufnr)
  update_diagnostics(buffer, bufnr, diagnostic.get(bufnr))
  update_git(buffer, bufnr, git_status(bufnr))
  refresh(bufnr)
end

local function initialize(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return
  end

  local buffer = {
    file = "",
    progress = "",
    git = "",
    lsp = "",
    diagnostics = "",
    statusline = "",
    spinner = 0,
    git_pending = false,
  }

  buffers[bufnr] = buffer
  update(buffer, bufnr)
end

local group = api.nvim_create_augroup("statusline", {})

autocmd({ "BufEnter", "BufFilePost", "FileType" }, {
  group = group,
  callback = function(args)
    local bufnr = args.buf

    if vim.bo[bufnr].buftype ~= "" then
      return
    end

    local buffer = buffers[bufnr]

    if buffer then
      update(buffer, bufnr)
    else
      initialize(bufnr)
    end
  end,
})

autocmd("BufWinEnter", {
  group = group,
  callback = function(args)
    local buffer = buffers[args.buf]

    if buffer and win_type(0) == "" then
      set_option("statusline", buffer.statusline, { win = 0 })
    end
  end,
})

autocmd("OptionSet", {
  group = group,
  pattern = { "modified", "readonly", "fileencoding", "fileformat" },
  callback = function()
    local bufnr = api.nvim_get_current_buf()
    local buffer = buffers[bufnr]

    if buffer then
      update_file(buffer, bufnr)
      refresh(bufnr)
    end
  end,
})

autocmd("DiagnosticChanged", {
  group = group,
  callback = function(args)
    local buffer = buffers[args.buf]

    if buffer then
      update_diagnostics(buffer, args.buf, args.data.diagnostics)
      refresh(args.buf)
    end
  end,
})

autocmd({ "LspAttach", "LspDetach" }, {
  group = group,
  callback = function(args)
    local buffer = buffers[args.buf]

    if buffer then
      local detached = args.event == "LspDetach" and args.data.client_id or nil

      update_lsp(buffer, args.buf, detached)
      update_diagnostics(buffer, args.buf, diagnostic.get(args.buf))
      refresh(args.buf)
    end
  end,
})

autocmd("LspProgress", {
  group = group,
  callback = function(args)
    local buffer = buffers[args.buf]

    if buffer then
      update_progress(buffer, args)
      refresh(args.buf)
    end
  end,
})

autocmd("User", {
  group = group,
  pattern = "GitSignsUpdate",
  callback = function(args)
    local buffer = buffers[args.buf]

    if buffer then
      update_git(buffer, args.buf, git_status(args.buf))
      refresh(args.buf)
    end
  end,
})

autocmd("BufDelete", {
  group = group,
  callback = function(args)
    buffers[args.buf] = nil
  end,
})

do
  for _, name in next, { "Add", "Change", "Delete" } do
    local diff = api.nvim_get_hl(0, { name = "Diff" .. name })
    api.nvim_set_hl(0, "Git" .. name, { fg = diff.bg })
  end

  local bufnr = api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype == "" then
    initialize(bufnr)
  end
end
