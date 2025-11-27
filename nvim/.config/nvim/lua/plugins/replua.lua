return {
    "mghaight/replua.nvim",
    keys = {
        {
            "<leader>ro",
            "<cmd>:RepluaOpen!<cr>",
            desc = "Replua open scratch buffer"
        },
        {
            "<leader>rr",
            "<cmd>:RepluaReset<cr>",
            desc = "Replua reset scratch buffer environment"
        }
    },
    opts = {
        open_command = "botright 15split",
        keymaps = {
            eval_line = "<leader>rl",
            eval_block = nil, -- disable
            eval_buffer = "<leader>ra",
        },
        intro_lines = {
            "-- replua.nvim",
            "-- Custom scratch buffer - happy hacking!",
            "",
        },
        print_prefix = "-- -> ",
        result_prefix = "-- => ",
        newline_after_result = true,
        persist_env = true,
    },
}
