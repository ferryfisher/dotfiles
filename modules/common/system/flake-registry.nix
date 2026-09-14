{ config, inputs, ... }:

{
  nix.settings.flake-registry = "";

  nixpkgs.flake = {
    setFlakeRegistry = config.nix.enable;
    setNixPath = false;
    source = inputs.nixpkgs;
  };
}
