{ inputs, pkgs }:

let
  inherit (inputs) self;
in
{
  format = pkgs.callPackage ./format.nix { inherit self; };
}
