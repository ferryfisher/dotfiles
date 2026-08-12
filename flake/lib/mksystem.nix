{ inputs }:

let
  inherit (inputs)
    darwin
    nixpkgs
    self
    ;
  inherit (nixpkgs) lib;

  mkSystem =
    {
      eval,
      moduleSet,
      platform,
      defaultArch,
    }:
    name:
    {
      arch ? defaultArch,
    }:
    let
      system = "${arch}-${platform}";
      inputs' = lib.mapAttrs (_: lib.mapAttrs (_: v: v.${system} or v)) inputs;
    in
    eval {
      specialArgs = {
        inherit inputs inputs' self;
      };

      modules = [
        (self + "/hosts/${name}")
        (self + "/modules/common")
        (self + "/modules/${moduleSet}")
        {
          nixpkgs.hostPlatform = system;
          networking.hostName = name;
        }
      ];
    };
in
{
  inherit mkSystem;

  nixos = mkSystem {
    eval = nixpkgs.lib.nixosSystem;
    moduleSet = "nixos";
    platform = "linux";
    defaultArch = "x86_64";
  };

  darwin = mkSystem {
    eval = darwin.lib.darwinSystem;
    moduleSet = "darwin";
    platform = "darwin";
    defaultArch = "aarch64";
  };
}
