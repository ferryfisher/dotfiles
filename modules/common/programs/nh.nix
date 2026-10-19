{ config, ... }:

{
  programs.nh = {
    enable = true;
    flake = config.networking.hostName;

    clean = {
      enable = true;
      extraArgs = "--keep 5 --optimise";
    };
  };
}
