{ mkShellNoCC, pkgs }:

mkShellNoCC {
  name = "dotfiles";

  packages = with pkgs; [
    git
    stow
  ];
}
