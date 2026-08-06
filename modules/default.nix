inputs:

let
  inherit (inputs) nixpkgs;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  forAllSystems =
    fn:
    nixpkgs.lib.genAttrs systems (
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
  checks = forAllSystems (pkgs: import ./checks { inherit inputs pkgs; });

  devShells = forAllSystems (pkgs: {
    default = pkgs.callPackage ./shell.nix { };
  });

  formatter = forAllSystems (pkgs: pkgs.callPackage ./formatter.nix { });

  packages = forAllSystems (pkgs: {
    default = pkgs.buildEnv {
      name = "user-packages";
      paths = import ./packages.nix { inherit inputs pkgs; };
    };
  });
}
