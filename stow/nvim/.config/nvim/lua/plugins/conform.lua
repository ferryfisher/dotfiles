return {
  "stevearc/conform.nvim",
  event = "BufWritePre",

  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format using conform.nvim",
    },
  },

  opts = {
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      css = { "prettier" },
      go = { "gofmt" },
      html = { "prettier" },
      javascript = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "nixfmt" },
      ocaml = { "ocamlformat" },
      python = { "ruff_fix", "ruff_format" },
      rust = { "rustfmt" },
      typescript = { "prettier" },
      yaml = { "prettier" },
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
  },
}
