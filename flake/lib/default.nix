{ inputs, lib }:

{
  mkSystem = import ./mksystem.nix { inherit inputs; };
  importModules = import ./importmodules.nix { inherit inputs lib; };
}
