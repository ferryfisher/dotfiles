--[=[
Config file may be separated in the future and joined together via modules.
]=]

local wezterm = require("wezterm")

local config = {
    max_fps = 120,

    color_scheme = "Kanagawa (Gogh)",
    font = wezterm.font("JetBrains Mono"),
    window_close_confirmation = "NeverPrompt",
    window_decorations = "MACOS_FORCE_SQUARE_CORNERS|RESIZE",

    -- Tab bar
    tab_max_width = 30,
    show_tab_index_in_tab_bar = false,
    switch_to_last_active_tab_when_closing_tab = true,
    use_fancy_tab_bar = true,
    adjust_window_size_when_changing_font_size = false,
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = true,

    window_background_opacity = 0.8,

    harfbuzz_features = {
        "calt=0",
        "clig=0",
        "liga=0",
    },

    window_padding = {
        left = 25,
        bottom = 8,
        top = 8,
    },

    window_frame = {
        active_titlebar_bg = "none",
        inactive_titlebar_bg = "none",
    },

    inactive_pane_hsb = {
        saturation = 1,
        brightness = 1,
    },
}

return config
