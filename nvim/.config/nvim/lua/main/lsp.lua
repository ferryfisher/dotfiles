local api = vim.api
local lsp = vim.lsp
local autocmd = api.nvim_create_autocmd
local group = api.nvim_create_augroup("ferry.lsp", { clear = true })

autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local client = lsp.get_client_by_id(args.data.client_id)

        if not client then return end

        local buf = args.buf
        local chars = client.server_capabilities.completionProvider.triggerCharacters

        if chars then
            local set = {}

            for _, v in next, chars do
                set[v] = true
            end

            for k in string.gmatch(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", '.')
            do
                if not set[k] then
                    table.insert(chars, k)
                end
            end
        end

        lsp.completion.enable(true, client.id, buf, { autotrigger = true })

        autocmd("CompleteChanged", {
            buffer = buf,
            group = group,
            callback = function()
                local info = vim.fn.complete_info({ "selected" })
                local bufnr = info.preview_bufnr

                if bufnr and vim.bo[bufnr].filetype == "" then
                    vim.bo[bufnr].filetype = "markdown"

                    local win = vim.wo[info.preview_winid]
                    win.conceallevel = 2
                    win.concealcursor = "niv"
                    win.wrap = true
                end
            end
        })
    end,
})

vim.lsp.enable({
    "asm-lsp",
    "lua_ls",
    "rust_analyzer",
    "nil_ls",
    "clangd",
    "ocamllsp",
})

vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = true,
    virtual_text = { current_line = true },
    signs = {
        text = { "●", "●", "●", "●" },
    },
})
