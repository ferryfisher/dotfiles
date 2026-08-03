local home_dir = os.getenv("HOME")
local build_path = home_dir .. "/.local/share/sketchybar_lua/"
local sbarlua = home_dir .. "/.config/sketchybar/sketchybar_lua/"
local sketchybar = sbarlua .. "sketchybar.so"

local lua_version = _VERSION:match("%d+%.%d+")
local profile_sbarlua = home_dir .. "/.nix-profile/lib/lua/" .. lua_version .. "/"

local function has_sketchybar()
    return io.open(profile_sbarlua .. "sketchybar.so") or io.open(sketchybar)
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

-- Add the sbarlua module to package.cpath

package.cpath = package.cpath
    .. ";"
    .. table.concat({
        profile_sbarlua .. "?.so",
        sbarlua .. "?.so",
    }, ";")

sbar = require("sketchybar")
sbar.exec("(cd helpers && make)")
