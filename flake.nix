{
  description = "ferry nix config";

  outputs = inputs: import ./. inputs;

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/NixOS/nix/pull/8892
    flake-schemas = {
      url = "github:ferryfisher/flake-schemas";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "";
    };

    # These are manually pinned to decouple, update the <rev-or-ref> manually.
    homebrew = {
      url = "github:Homebrew/brew/6.0.17";
      flake = false;
    };

    homebrew-cask = {
      url = "github:Homebrew/homebrew-cask/b8fadeeaa920a1234e4e1d6fff9001260b225496";
      flake = false;
    };

    homebrew-core = {
      url = "github:Homebrew/homebrew-core/3c8cb71469a83df3cedf38c570160001c08af138";
      flake = false;
    };
  };
}
