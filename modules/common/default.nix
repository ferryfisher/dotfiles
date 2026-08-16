{ lib, ... }:

{
  imports = [
    ./nix
    ./fonts.nix
    ./options.nix
    ./packages.nix
    ./programs.nix
  ];

  time.timeZone = lib.mkDefault "America/Los_Angeles";
}
