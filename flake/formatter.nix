{ pkgs, treefmt }:

treefmt.withConfig {
  settings = {
    allow-missing-formatter = false;
    on-unmatched = "warn";
    tree-root-file = "flake.nix";

    excludes = [
      ".gitignore"
      "*.lock"
    ];

    formatter = {
      beautysh = {
        command = "beautysh";
        includes = [
          "*.sh"
          "*.bash"
        ];
      };

      deadnix = {
        command = "deadnix";
        options = [ "--edit" ];
        includes = [ "*.nix" ];
        priority = 1;
      };

      nixfmt = {
        command = "nixfmt";
        includes = [ "*.nix" ];
        priority = 3;
      };

      prettier = {
        command = "prettier";
        options = [ "--write" ];
        includes = [
          "*.md"
          "*.json"
          "*.jsonc"
          "*.yaml"
          "*.yml"
        ];
      };

      shellcheck = {
        command = "shellcheck";
        includes = [
          "*.sh"
          "*.bash"
          "*.envrc"
          "*.envrc.*"
        ];
      };

      statix = {
        command = pkgs.writeShellScript "statix-fix" ''
          for file in "$@"; do
            statix fix "$file"
          done
        '';
        includes = [ "*.nix" ];
        priority = 2;
      };

      stylua = {
        command = "stylua";
        includes = [ "*.lua" ];
      };

      taplo = {
        command = "taplo";
        options = [ "format" ];
        includes = [
          "*.toml"
        ];
      };

      typos = {
        command = "typos";
        options = [ "--write-changes" ];
        includes = [
          "*.md"
        ];
      };
    };
  };

  runtimeInputs = with pkgs; [
    beautysh
    deadnix
    nixfmt
    prettier
    shellcheck
    statix
    stylua
    taplo
    typos
  ];
}
