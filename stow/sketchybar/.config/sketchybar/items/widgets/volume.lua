local colors = require("colors").sections.widgets.volume
local icons = require("icons")

local popup_width = 300

local volume_icon = sbar.add("item", "widgets.volume", {
    position = "right",
    icon = {
        color = colors.icon,
    },
    label = { drawing = false },
    background = { drawing = false },
    popup = {
        align = "center",
        y_offset = 2,
    },
    padding_right = 12,
})

local volume_slider = sbar.add("slider", popup_width, {
    position = "popup." .. volume_icon.name,
    slider = {
        highlight_color = colors.slider.highlight,
        background = {
            height = 12,
            corner_radius = 6,
            color = colors.slider.bg,
            border_color = colors.slider.border,
            border_width = 2,
        },
        knob = {
            string = "􀀁",
            drawing = true,
        },
    },
    background = { color = colors.bg1, height = 2, y_offset = -20 },
    click_script = 'osascript -e "set volume output volume $PERCENTAGE"',
})

volume_icon:subscribe("volume_change", function(env)
    local icon = icons.volume._0
    local volume = tonumber(env.INFO)
    if volume > 60 then
        icon = icons.volume._100
    elseif volume > 30 then
        icon = icons.volume._66
    elseif volume > 10 then
        icon = icons.volume._33
    elseif volume > 0 then
        icon = icons.volume._10
    end

    volume_icon:set({ icon = icon })
    volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
    local drawing = volume_icon:query().popup.drawing == "on"
    if not drawing then
        return
    end
    volume_icon:set({ popup = { drawing = false } })
    sbar.remove("/volume.device\\.*/")
end

local function volume_toggle_details(env)
    if env.BUTTON == "right" then
        sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
        return
    end

    local should_draw = volume_icon:query().popup.drawing == "off"
    if should_draw then
        volume_icon:set({ popup = { drawing = true } })
    else
        volume_collapse_details()
    end
end

local function volume_scroll(env)
    local delta = env.SCROLL_DELTA
    sbar.exec(
        'osascript -e "set volume output volume (output volume of (get volume settings) + '
            .. delta
            .. ')"'
    )
end

volume_icon:subscribe("mouse.clicked", function(env)
    volume_toggle_details(env)
    -- sbar.animate("tanh", 8, function()
    -- 	volume_icon:set({
    -- 		background = {
    -- 			shadow = {
    -- 				distance = 0,
    -- 			},
    -- 		},
    -- 		y_offset = -4,
    -- 		padding_left = 8,
    -- 		padding_right = 0,
    -- 	})
    -- 	volume_icon:set({
    -- 		background = {
    -- 			shadow = {
    -- 				distance = 4,
    -- 			},
    -- 		},
    -- 		y_offset = 0,
    -- 		padding_left = 4,
    -- 		padding_right = 4,
    -- 	})
    -- end)
end)

volume_icon:subscribe("mouse.scrolled", volume_scroll)
