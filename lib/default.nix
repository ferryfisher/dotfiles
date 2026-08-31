{ inputs, lib }:

{
  importModules = import ./importmodules.nix { inherit inputs lib; };
  mkSystem = import ./mksystem.nix { inherit inputs; };
}
