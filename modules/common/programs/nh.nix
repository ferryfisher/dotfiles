{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.nh ];
  environment.variables.NH_FLAKE = config.networking.hostName;
}
