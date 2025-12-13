return {
    "nvim-treesitter/nvim-treesitter",

    event = "BufReadPre",

    opts = {
        ensure_installed = {
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
            "python",
            "rust",
            "toml",
            "yaml",
            "vim",
            "vimdoc",
            "query"
        },

        highlight = { enable = true, disable = "help" },
        indent = { enable = true },
    }
}
