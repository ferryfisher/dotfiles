local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("ferry", {})

autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch" })
    end
})

autocmd("InsertEnter", {
    desc = "Autopairs",
    group = group,
    once = true,
    callback = function()
        require("main.pairs")
    end
})

autocmd("UIEnter", {
    desc = "Entry point",
    group = group,
    once = true,
    callback = function()
        vim.schedule(function()
            require("main.keymap")
            require("main.statusline")
            require("main.lsp")

            vim.cmd.packadd("nvim.undotree")
        end)
    end
})

require("main.option")
