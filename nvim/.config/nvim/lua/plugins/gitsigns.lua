return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    keys = {
        {
            "<leader>g[",
            mode = "n",
            "<cmd>Gitsigns prev_hunk<CR>",
            desc = "Gitsigns prev_hunk"
        },
        {
            "<leader>g]",
            mode = "n",
            "<cmd>Gitsigns next_hunk<CR>",
            desc = "Gitsigns next_hunk"
        }
    },
    opts = {}
}
