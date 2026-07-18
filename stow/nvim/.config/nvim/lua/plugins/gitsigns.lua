return {
    "lewis6991/gitsigns.nvim",

    event = "BufReadPre",

    keys = {
        {
            "<leader>g[",
            "<cmd>Gitsigns prev_hunk<CR>",
            desc = "Gitsigns prev_hunk"
        },
        {
            "<leader>g]",
            "<cmd>Gitsigns next_hunk<CR>",
            desc = "Gitsigns next_hunk"
        }
    },

    opts = {}
}
