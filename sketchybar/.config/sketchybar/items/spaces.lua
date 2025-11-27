local colors = require("colors").sections.spaces
local icons = require "icons"
local icon_map = require "helpers.icon_map"

-- local spaces = {'一', '二', '三', '四', '五', '六', '七', '八', '九', '十'}
local spaces = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X" }

for i = 1, 10 do
    local space = sbar.add("space", "space." .. i, {
        space = i,
        icon = {
            string = spaces[i] .. " " .. icons.separators.right,
            color = colors.icon.color,
            highlight_color = colors.label.highlight,
            y_offset = 1,
            padding_left = 8,
            padding_right = 0,
        },
        label = {
            font = "sketchybar-app-font:Regular:13.0",
            string = "space",
            color = colors.label.color,
            y_offset = 0,
            highlight_color = colors.label.highlight,
            padding_right = 12,
        },
        padding_left = i == 1 and 0 or 4,
    })

    -- Highlight active space
    space:subscribe("space_change", function(env)
        local selected = env.SELECTED == "true"
        space:set {
            icon = { highlight = selected },
            label = { highlight = selected },
        }

        if selected then
            sbar.animate("tanh", 8, function()
                space:set {
                    background = { shadow = { distance = 0 } },
                    y_offset = -4,
                    padding_left = 8,
                    padding_right = 0,
                }
                space:set {
                    background = { shadow = { distance = 4 } },
                    y_offset = 0,
                    padding_left = 4,
                    padding_right = 4,
                }
            end)
        end
    end)

    -- Update app icons when windows change
    space:subscribe("space_windows_change", function(env)
        if tonumber(env.INFO.space) ~= i then return end
        local no_app = true
        local icon_line = ""
        for app in pairs(env.INFO.apps) do
            no_app = false
            local lookup = icon_map[app]
            local icon = lookup or icon_map["default"]
            icon_line = icon_line .. " " .. icon
        end
        sbar.animate("tanh", 10, function()
            space:set { label = no_app and " " or icon_line }
        end)
    end)
end
