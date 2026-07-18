local permissions_hlgroup = {
    ["-"] = "NonText",
    ["r"] = "DiagnosticHint",
    ["w"] = "DiagnosticWarn",
    ["x"] = "DiagnosticError",
    ["s"] = "DiagnosticInfo"
}

local type_hlgroup = {
    ["-"] = "NonText",
    ["d"] = "Directory",
    ["l"] = "Special",
    ["p"] = "Conceal",
    ["s"] = "Underlined"
}

return {
    "stevearc/oil.nvim",

    keys = {
        {
            "-",
            "<cmd>Oil<cr>",
            desc = "Oil parent directory"
        }
    },

    opts = {
        delete_to_trash = true,
        watch_for_changes = true,

        columns = {
            {
                "type",
                icons = {
                    directory = "d",
                    fifo = "p",
                    file = "-",
                    link = "l",
                    socket = "s",
                },
                highlight = function(string)
                    return type_hlgroup[string] or type_hlgroup["-"]
                end
            },
            {
                "permissions",
                highlight = function(string)
                    local hl = {}

                    for i = 1, #string do
                        table.insert(
                            hl,
                            {
                                permissions_hlgroup[string:sub(i, i)],
                                i - 1, i
                            }
                        )
                    end

                    return hl or permissions_hlgroup["-"]
                end
            },
            { "size",  align = "right",     highlight = "Number" },
            { "mtime", highlight = "String" },
        },

        keymaps = {
            ["<M-s>"] = { "actions.select", opts = { horizontal = true } },
            ["<M-v>"] = { "actions.select", opts = { vertical = true } },
            ["<C-h>"] = false,
            ["<C-j>"] = false,
            ["<C-k>"] = false,
            ["<C-l>"] = false,
            ["<C-s>"] = false
        },

        view_options = {
            show_hidden = true,
            is_always_hidden = function(name)
                return name == ".."
            end
        }
    }
}
