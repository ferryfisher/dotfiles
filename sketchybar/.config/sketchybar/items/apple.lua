local colors = require("colors").sections
local icons = require "icons"

local apple = sbar.add("item", {
    icon = {
        font = { size = 22 },
        string = icons.apple,
        padding_right = 15,
        padding_left = 15,
        y_offset = 1,
        color = colors.apple.logo,
    },

    label = {
        drawing = false,
    },

    background = {
        color = colors.apple.bg,
        shadow = {
            color = colors.apple.shadow
        }
    },

    click_script = "sleep 0.5; sketchybar --reload"
})

apple:subscribe("mouse.clicked", function()
    sbar.animate("tanh", 8, function()
        apple:set {
            background = {
                shadow = {
                    distance = 0,
                },
            },
            y_offset = -4,
            padding_left = 8,
            padding_right = 0,
        }
        apple:set {
            background = {
                shadow = {
                    distance = 4,
                },
            },
            y_offset = 0,
            padding_left = 4,
            padding_right = 4,
        }
    end)
end)
