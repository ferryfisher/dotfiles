{ lib, pkgs, ... }:

{
  launchd.daemons.nix-gc = {
    command = "${lib.meta.getExe pkgs.nh} clean all --keep 5 --optimise";
    path = [ "/nix/var/nix/profiles/default/bin" ];

    serviceConfig = {
      Label = "org.nix.nix-gc";
      StartCalendarInterval = {
        Hour = 12;
        Minute = 0;
      };
      StandardErrorPath = "/var/log/nix-gc.error.log";
      StandardOutPath = "/var/log/nix-gc.out.log";
    };
  };
}
