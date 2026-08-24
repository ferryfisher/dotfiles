{ config, pkgs, ... }:

let
  prefix = "sketchybar_${config.me.mainUser}";
in
{
  environment = {
    pathsToLink = [ "/lib" ];
    systemPackages = with pkgs; [
      lua5_5 # sketchybar lua
      sbarlua # sketchybar config with lua
      sketchybar # macos menu bar
      sketchybar-app-font # sketchybar font
    ];
  };

  launchd.agents.sketchybar = {
    command = "${pkgs.sketchybar}/bin/sketchybar";

    path = with pkgs; [
      lua5_5
      "/run/current-system/sw/bin"
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
    ];

    serviceConfig = {
      Label = "org.nix.sketchybar";

      RunAtLoad = true;
      KeepAlive = true;

      StandardOutPath = "/tmp/${prefix}.out.log";
      StandardErrorPath = "/tmp/${prefix}.error.log";
    };
  };
}
