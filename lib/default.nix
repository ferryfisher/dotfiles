{ inputs, lib }:

{
  importModules = import ./import-modules.nix { inherit inputs lib; };
  mkSystem = import ./mk-system.nix { inherit inputs; };
}
