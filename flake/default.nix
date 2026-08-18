inputs:

let
  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;

  mkSystem = self.lib.mkSystem;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  forAllSystems = fn: lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});
in
{
  checks = forAllSystems (pkgs: import ./checks { inherit inputs pkgs; });

  devShells = forAllSystems (pkgs: {
    default = pkgs.callPackage ./shell.nix { };
  });

  formatter = forAllSystems (pkgs: pkgs.callPackage ./formatter.nix { });

  lib = import ./lib { inherit inputs; };

  exportedSchemas = import ./schemas;

  schemas = self.exportedSchemas // {
    inherit (inputs.flake-schemas.exportedSchemas)
      checks
      darwinConfigurations
      devShells
      exportedSchemas
      formatter
      nixosConfigurations
      schemas
      ;
  };

  darwinConfigurations = builtins.mapAttrs mkSystem.darwin {
    rho = { };
  };
}
