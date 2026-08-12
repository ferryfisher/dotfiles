{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lua5_5 # sketchybar lua
    sbarlua # sketchybar config with lua
    sketchybar # macos menu bar
    sketchybar-app-font # sketchybar font
  ];
}
