{ pkgs, ... }:

{
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

      StandardOutPath = "/tmp/sketchybar_ferry.out.log";
      StandardErrorPath = "/tmp/sketchybar_ferry.error.log";
    };
  };
}
