local colors = require("colors").sections.calendar
local settings = require "settings"

local cal = sbar.add("item", {
    icon = {
        padding_left = 10,
        color = colors.label,
        font = {
            size = 12,
            family = settings.font.numbers,
            style = settings.font.style_map["Regular"],
        },
    },
    label = {
        align = "left",
        padding_right = 6,
    },
    padding_left = 10,
    position = "right",
    update_freq = 5,
    click_script = "open -a 'Calendar'",
})

cal:subscribe("mouse.clicked", function()
    sbar.animate("tanh", 8, function()
        cal:set {
            background = {
                shadow = {
                    distance = 0,
                },
            },
            y_offset = -4,
            padding_left = 14,
            padding_right = 0,
        }
        cal:set {
            background = {
                shadow = {
                    distance = 4,
                },
            },
            y_offset = 0,
            padding_left = 10,
            padding_right = 4,
        }
    end)
end)

-- english date
cal:subscribe({ "forced", "routine", "system_woke" }, function()
    local hour   = tonumber(os.date("%I"))
    local minute = os.date("%M")
    local ampm   = os.date("%p")
    cal:set {
        icon = os.date("%a %b %d ") .. hour .. ":" .. minute .. " " .. ampm
    }
end)
