{ inputs, pkgs }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (inputs.nixpkgs.lib) mapAttrs;

  # equivalent to inputs but with system already selected
  inputs' = mapAttrs (_: mapAttrs (_: v: v.${pkgs.stdenv.hostPlatform.system} or v)) inputs;
in
(
  with pkgs;
  [
    ### main
    bash
    direnv
    emacs
    fastfetch
    fzf
    git
    gnupg
    htop
    inputs'.neovim-nightly-overlay.packages.neovim
    nerd-fonts.jetbrains-mono
    nix-direnv
    ripgrep
    starship
    stow
    tmux
    tree-sitter
    yazi

    ### language tooling (disdain for project envs)
    asm-lsp
    cargo
    clang-tools
    go
    lua-language-server
    nixd
    nixfmt
    ocamlPackages.ocamlformat
    ocamlPackages.ocaml-lsp
    prettier
    ruff
    rustc
    rustfmt
    rust-analyzer
    stylua

    ### misc
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
      ]
    )) # for emacs
  ]
  ++ lib.optionals isDarwin [
    lua5_5 # sketchybar lua
    sketchybar # macos menu bar
    sketchybar-app-font # sketchybar font
  ]
  ++ lib.optionals isLinux [
    firefox
    ghostty
  ]
)
