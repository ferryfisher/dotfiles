return {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },

    keys = {
        {
            "<leader>fb",
            "<cmd>FzfLua buffers<cr>",
            desc = "FzfLua buffers",
        },
        {
            "<leader>ff",
            "<cmd>FzfLua files<cr>",
            desc = "FzfLua files",
        },
        {
            "<leader>fh",
            "<cmd>FzfLua help_tags<cr>",
            desc = "FzfLua help_tags",
        },
        {
            "<leader>f/",
            "<cmd>FzfLua lgrep_curbuf<cr>",
            desc = "FzfLua lgrep_curbuf",
        },
        {
            "<leader>fl",
            "<cmd>FzfLua live_grep<cr>",
            desc = "FzfLua live_grep",
        },
        {
            "<leader>fd",
            "<cmd>FzfLua lsp_document_diagnostics<cr>",
            desc = "FzfLua lsp_document_diagnostics",
        },
        {
            "<leader>fs",
            "<cmd>FzfLua lsp_document_symbols<cr>",
            desc = "FzfLua lsp_document_symbols",
        },
        {
            "<leader>fD",
            "<cmd>FzfLua lsp_workspace_diagnostics<cr>",
            desc = "FzfLua lsp_workspace_diagnostics",
        },
        {
            "<leader>fo",
            "<cmd>FzfLua oldfiles<cr>",
            desc = "FzfLua oldfiles",
        },
        {
            "<leader>fq",
            "<cmd>FzfLua quickfix<cr>",
            desc = "FzfLua quickfix list",
        },
        {
            "<leader>fQ",
            "<cmd>FzfLua lgrep_quickfix<cr>",
            desc = "FzfLua search quickfix list",
        },
        {
            "<leader>gc",
            "<cmd>FzfLua git_commits<cr>",
            desc = "git_commits FzfLua",
        },
        {
            "<leader>gs",
            "<cmd>FzfLua git_status<cr>",
            desc = "git_status FzfLua",
        },
        {
            "<leader>gf",
            "<cmd>FzfLua git_files<cr>",
            desc = "git_files FzfLua",
        },
    },

    opts = {
        { "max-perf", "ivy" },

        files = { cwd_prompt_shorten_len = 96 },

        winopts = {
            backdrop = 100,
            height = 0.4,
            preview = { vertical = "right:50%", default = "builtin" },
        },

        lsp = { symbols = { symbol_style = 3 } },
    },
}
