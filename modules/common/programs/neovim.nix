{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim
  ];

  preferences = {
    editor = "nvim";
    manpager = "nvim +Man!";
  };
}
