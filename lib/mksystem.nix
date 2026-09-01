{ inputs }:

let
  inherit (inputs)
    darwin
    nixpkgs
    self
    ;

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
    eval {
      specialArgs = {
        inherit inputs self;
      };

      modules = self.lib.importModules [
        (self + "/hosts/${name}")
        (self + "/modules/common")
        (self + "/modules/${moduleSet}")
        {
          nixpkgs.hostPlatform = arch + "-" + platform;
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
