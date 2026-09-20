{ config, inputs, ... }:

{
  nix.settings.flake-registry = "";

  nixpkgs.flake = {
    setFlakeRegistry = config.nix.enable;
    source = inputs.nixpkgs;
  };
}
