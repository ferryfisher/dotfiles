{ config, pkgs, ... }:

{
  environment = {
    systemPackages = [ pkgs.nh ];
    variables.NH_FLAKE = config.networking.hostName;
  };
}
