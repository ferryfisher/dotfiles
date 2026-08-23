{
  inputs',
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    ### main
    emacs
    fastfetch
    fzf
    git
    gnupg
    htop
    inputs'.neovim-nightly-overlay.packages.neovim
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

    ### misc
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
      ]
    )) # for emacs
  ];
}
