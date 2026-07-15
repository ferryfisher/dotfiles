local colors = require("colors").sections.bar

-- Equivalent to the --bar domain
sbar.bar {
    topmost = "window",
    height = 50,
    color = colors.bg,
    padding_right = 0,
    padding_left = 0,
    margin = 6,
    corner_radius = 10,
    y_offset = -8,
    border_color = colors.border,
    border_width = 0,
    blur_radius = 32,
}
