{ mkShellNoCC, pkgs }:

mkShellNoCC {
  name = "dotfiles";

  packages = (
    with pkgs;
    [
      deadnix
      git
      nixfmt
      sops
      statix
    ]
  );
}
