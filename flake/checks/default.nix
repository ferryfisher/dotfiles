{ pkgs, self }:

{
  format = pkgs.callPackage ./format.nix { inherit self; };
}
