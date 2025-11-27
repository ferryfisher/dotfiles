return {
    "stevearc/conform.nvim",

    event = "BufReadPost",

    keys = {
        {
            "<leader>lf",
            mode = "n",
            "<cmd>lua require('conform').format({ async = true })<CR>",
            desc = "Format using conform.nvim"
        }
    },

    opts = {
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },

        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            go = { "gofmt" },
            lua = { "stylua" },
            ocaml = { "ocamlformat" },
            python = { "ruff_fix", "ruff_format" },
            rust = { "rustfmt" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            css = { "prettier" },
            markdown = { "prettier" },
            json = { "prettier" },
            html = { "prettier" },
            yaml = { "prettier" },
        },

        default_format_opts = {
            lsp_format = "fallback",
        }
    }
}
