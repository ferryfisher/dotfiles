local api = vim.api
local autocmd = api.nvim_create_autocmd
local group = api.nvim_create_augroup("ferry.lsp", { clear = true })
local lsp = vim.lsp

autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client = lsp.get_client_by_id(args.data.client_id)

    if not client or not client:supports_method("textDocument/completion") then
      return
    end

    local provider = client.server_capabilities.completionProvider

    if not provider then
      return
    end

    local chars = provider.triggerCharacters or {}
    local seen = {}

    for _, char in next, chars do
      seen[char] = true
    end

    local n = #chars
    local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    for i = 1, #alphabet do
      local char = alphabet:sub(i, i)

      if not seen[char] then
        n = n + 1
        chars[n] = char
      end
    end

    provider.triggerCharacters = chars

    lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
  end,
})

lsp.log.set_level(vim.log.levels.OFF)

lsp.enable({
  "asm-lsp",
  "clangd",
  "lua_ls",
  "nixd",
  "ocamllsp",
  "rust_analyzer",
})

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = true,
  virtual_text = { current_line = true },
  signs = {
    text = { "●", "●", "●", "●" },
  },
})
