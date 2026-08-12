{ lib, ... }:

{
  imports = [
    ./nix
    ./fonts.nix
    ./packages.nix
    ./programs.nix
  ];

  time.timeZone = lib.mkDefault "America/Los_Angeles";
}
