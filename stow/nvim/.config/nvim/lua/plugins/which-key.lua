return {
    "folke/which-key.nvim",

    event = "UIEnter",

    opts = {
        delay = 400, -- ms

        icons = {
            mappings = false,

            keys = {
                C = "C-",
                M = "M-",
                S = "S-",
                BS = "DEL ",
                CR = "RET ",
                NL = "NL ",
                Esc = "ESC ",
                Tab = "Tab ",
                Up = "up ",
                Down = "down ",
                Left = "left ",
                Right = "right ",
                Space = "SPC ",
            },
        },

        spec = {
            { "<leader>f", group = "FzfLua" },
            { "<leader>g", group = "Git" },
            { "<leader>l", group = "LSP" },
            { "<leader>r", group = "Replua" },
        },
    },
}
