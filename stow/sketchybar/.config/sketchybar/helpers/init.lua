local home_dir = os.getenv("HOME")
local sbar_path = home_dir .. "/.config/sketchybar/sketchybar_lua/"
local build_path = home_dir .. "/.local/share/sketchybar_lua/"

local sketchybar = sbar_path .. "sketchybar.so"

local function has_sketchybar()
    return io.open(sketchybar)
end

if not has_sketchybar() then
    os.execute(
        [[
        set -e

        git clone https://github.com/FelixKratz/SbarLua /tmp/SbarLua
        cd /tmp/SbarLua/
        make install
        rm -rf /tmp/SbarLua/
        ]]
            .. string.format('mv "%s" "%s"', build_path .. "sketchybar.so", sketchybar)
            .. "\n"
            .. string.format('rm -rf "%s"', build_path)
    )
end

-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";" .. sbar_path .. "?.so"

sbar = require("sketchybar")
sbar.exec("(cd helpers && make)")
