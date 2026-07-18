return {
    "stevearc/conform.nvim",

    event = "BufReadPost",

    keys = {
        {
            "<leader>lf",
            "<cmd>lua require('conform').format({ async = true })<CR>",
            desc = "Format using conform.nvim"
        }
    },

    opts = {
        format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 500,
        },

        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            css = { "prettier" },
            go = { "gofmt" },
            html = { "prettier" },
            javascript = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            markdown = { "prettier" },
            nix = { "nixfmt" },
            ocaml = { "ocamlformat" },
            python = { "ruff_fix", "ruff_format" },
            rust = { "rustfmt" },
            typescript = { "prettier" },
            yaml = { "prettier" },
        },

        default_format_opts = {
            lsp_format = "fallback",
        }
    }
}
