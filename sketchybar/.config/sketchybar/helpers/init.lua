-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";" .. os.getenv("HOME") .. "/.config/sketchybar/sketchybar_lua/?.so"

sbar = require "sketchybar"
sbar.exec("(cd helpers && make)")
