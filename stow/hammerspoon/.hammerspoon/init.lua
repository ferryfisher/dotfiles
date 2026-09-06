local PaperWM = assert(hs.loadSpoon("PaperWM"), "PaperWM.spoon could not be loaded.")
local alert = hs.alert
alert.defaultStyle = {
    strokeWidth = 2,
    strokeColor = { white = 1, alpha = 0.65 },
    fillColor = { white = 0, alpha = 0.75 },
    textColor = { white = 1, alpha = 0.75 },
    textFont = ".AppleSystemUIFont",
    textSize = 15,
    radius = 15,
    atScreenEdge = 2,
    fadeInDuration = 0,
    fadeOutDuration = 0,
    padding = nil,
}
local filter = hs.window.filter
local modal = hs.hotkey.modal.new({ "alt" }, "space")

local actions = PaperWM.actions.actions()

local hotkeys = {
    { {}, "h", nil, actions.focus_left },
    { {}, "j", nil, actions.focus_down },
    { {}, "k", nil, actions.focus_up },
    { {}, "l", nil, actions.focus_right },

    { {}, "n", nil, actions.focus_next },
    { { "shift" }, "N", nil, actions.focus_prev },

    { { "shift" }, "H", nil, actions.swap_left },
    { { "shift" }, "J", nil, actions.swap_down },
    { { "shift" }, "K", nil, actions.swap_up },
    { { "shift" }, "L", nil, actions.swap_right },

    { {}, "c", nil, actions.center_window },
    { {}, "f", nil, actions.full_width },

    { { "shift" }, "=", nil, actions.increase_width },
    { {}, "-", nil, actions.decrease_width },
    { { "shift" }, "\\", nil, actions.increase_height },
    { { "shift" }, "-", nil, actions.decrease_height },

    { {}, "i", nil, actions.slurp_in },
    { {}, "o", nil, actions.barf_out },

    { {}, "s", nil, actions.split_screen },
    { { "shift" }, "S", nil, actions.toggle_stack },

    { {}, "q", nil, actions.toggle_floating },
    { { "shift" }, "F", nil, actions.focus_floating },

    { { "ctrl", "shift" }, "1", nil, actions.move_window_1 },
    { { "ctrl", "shift" }, "2", nil, actions.move_window_2 },
    { { "ctrl", "shift" }, "3", nil, actions.move_window_3 },
    { { "ctrl", "shift" }, "4", nil, actions.move_window_4 },
    { { "ctrl", "shift" }, "5", nil, actions.move_window_5 },
    { { "ctrl", "shift" }, "6", nil, actions.move_window_6 },
    { { "ctrl", "shift" }, "7", nil, actions.move_window_7 },
    { { "ctrl", "shift" }, "8", nil, actions.move_window_8 },
    { { "ctrl", "shift" }, "9", nil, actions.move_window_9 },

    {
        {},
        "escape",
        function()
            modal:exit()
        end,
    },
}

local uuid = nil

function modal:entered()
    uuid = alert("PaperWM", "")
end

function modal:exited()
    alert.closeSpecific(uuid)
end

for _, hotkey in next, hotkeys do
    local mods, key, message, fn = table.unpack(hotkey)

    modal:bind(mods, key, message, function()
        if not fn then
            return
        end

        fn()

        modal:exit()
    end)
end

filter.copy(PaperWM.window_filter):subscribe(filter.windowCreated, actions.full_width)

PaperWM.external_bar = { top = 32 }
PaperWM.window_gap = 5

PaperWM:start()
