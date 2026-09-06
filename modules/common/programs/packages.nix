{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ### main
    bat
    fastfetch
    fzf
    git
    gnupg
    htop
    nix-output-monitor
    ripgrep
    starship
    stow
    tmux
    tree-sitter
    yazi

    ### language/editor tooling
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
  ];
}
