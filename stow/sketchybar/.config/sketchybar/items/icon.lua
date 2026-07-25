local colors = require("colors").sections
local icons = require("icons")

local icon = sbar.add("item", {
    icon = {
        font = { size = 22 },
        string = icons.nix,
        padding_right = 15,
        padding_left = 15,
        y_offset = 1,
        color = colors.nix.logo,
    },

    label = {
        drawing = false,
    },

    background = {
        color = colors.nix.bg,
        shadow = {
            color = colors.nix.shadow,
        },
    },

    click_script = "sketchybar --reload",
})

icon:subscribe("mouse.clicked", function()
    sbar.animate("tanh", 8, function()
        icon:set({
            background = {
                shadow = {
                    distance = 0,
                },
            },
            y_offset = -4,
            padding_left = 8,
            padding_right = 0,
        })
        icon:set({
            background = {
                shadow = {
                    distance = 4,
                },
            },
            y_offset = 0,
            padding_left = 4,
            padding_right = 4,
        })
    end)
end)
