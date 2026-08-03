local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("ferry", {})

local parsers = {
    "c",
    "cmake",
    "cpp",
    "css",
    "diff",
    "html",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "ocaml",
    "python",
    "rust",
    "query",
    "toml",
    "yaml",
    "vim",
    "vimdoc",
}

autocmd("CmdlineEnter", {
    group = group,
    once = true,
    callback = function()
        require("vim._core.ui2").enable({})
    end,
})

autocmd("FileType", {
    desc = "Treesitter",
    pattern = parsers,
    group = group,
    callback = function(opts)
        local lang = vim.treesitter.language.get_lang(vim.bo[opts.buf].filetype)

        if not lang then
            return
        end

        if not vim.treesitter.language.add(lang) then
            require("nvim-treesitter").install(lang, { summary = true })
        end

        if vim.treesitter.language.add(lang) then
            vim.treesitter.start(opts.buf, lang)

            local wo = vim.wo[0][0]
            wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            wo.foldmethod = "expr"

            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

autocmd({ "TextPutPost", "TextYankPost" }, {
    group = group,
    callback = function()
        vim.hl.hl_op({ higroup = "IncSearch" })
    end,
})

autocmd("InsertEnter", {
    desc = "Autopairs",
    group = group,
    once = true,
    callback = function()
        require("main.pairs")
    end,
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

            vim.lsp.log.set_level(vim.log.levels.OFF)

            local packadd = vim.cmd.packadd
            packadd("nohlsearch")
            packadd("nvim.undotree")
        end)
    end,
})

require("main.options")
