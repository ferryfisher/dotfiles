{ pkgs, self }:

{
  fmt = pkgs.callPackage ./fmt.nix { inherit self; };
}
