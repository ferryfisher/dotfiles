inputs:

let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (lib) mapAttrs;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  forAllSystems =
    fn:
    lib.genAttrs systems (
      system:
      fn (
        import nixpkgs {
          inherit
            system
            ;
          config = {
            allowAliases = false;
            allowBroken = false;
            allowUnfree = true;
            allowUnsupportedSystem = false;
            allowVariants = false;
          };
        }
      )
    );
in
{
  packages = forAllSystems (
    pkgs:
    let
      inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

      # equivalent to inputs but with system already selected
      inputs' = mapAttrs (_: mapAttrs (_: v: v.${pkgs.stdenv.hostPlatform.system} or v)) inputs;
    in
    {
      default = pkgs.buildEnv {
        name = "user-packages";
        paths =
          with pkgs;
          [
            ### main
            bash
            emacs
            fastfetch
            fzf
            git
            gnupg
            htop
            inputs'.neovim-nightly-overlay.packages.neovim
            nerd-fonts.jetbrains-mono
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
            # stylua

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
          ];
      };
    }
  );
}
