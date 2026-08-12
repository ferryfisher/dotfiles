{
  description = "ferry nix packages";

  outputs = inputs: import ./flake inputs;

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
  };
}
