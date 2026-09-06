{ lib, pkgs, ... }:

{
  launchd.daemons.nix-gc = {
    command = "${lib.meta.getExe pkgs.nh} clean all --keep 5 --optimise";

    path = [
      "/nix/var/nix/profiles/default/bin"
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
    ];

    serviceConfig = {
      Label = "org.nix.nix-gc";
      StartCalendarInterval = {
        Hour = 13;
        Minute = 0;
      };
      LowPriorityIO = true;
      ProcessType = "Background";
      StandardErrorPath = "/var/log/nix-gc.log";
      StandardOutPath = "/var/log/nix-gc.log";
    };
  };
}
