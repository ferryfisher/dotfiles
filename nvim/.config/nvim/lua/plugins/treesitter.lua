return {
    "nvim-treesitter/nvim-treesitter",

    event = "BufReadPre",

    opts = {
        ensure_installed = {
            "c",
            "cpp",
            "json",
            "lua",
            "python",
            "rust",
            "toml",
            "vim"
        },

        highlight = { enable = true, disable = "help" },
        indent = { enable = true },
    }
}
