inputs:

let
  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;
  inherit (self.lib) mkSystem;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  forAllSystems = fn: lib.attrsets.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});
in
{
  checks = forAllSystems (pkgs: import ./flake/checks { inherit pkgs self; });

  devShells = forAllSystems (pkgs: {
    default = pkgs.callPackage ./shell.nix { };
  });

  exportedSchemas = import ./flake/schemas;

  formatter = forAllSystems (pkgs: pkgs.callPackage ./flake/formatter.nix { });

  lib = import ./lib { inherit inputs lib; };

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
