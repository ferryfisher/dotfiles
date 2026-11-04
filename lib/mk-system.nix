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
      modules = self.lib.importModules [
        (self + "/hosts/${name}")
        (self + "/modules/common")
        (self + "/modules/${moduleSet}")
        {
          nixpkgs.hostPlatform = arch + "-" + platform;
          networking.hostName = name;
        }
      ];

      specialArgs = { inherit inputs self; };
    };
in
{
  inherit mkSystem;

  darwin = mkSystem {
    eval = darwin.lib.darwinSystem;
    moduleSet = "darwin";
    platform = "darwin";
    defaultArch = "aarch64";
  };

  nixos = mkSystem {
    eval = nixpkgs.lib.nixosSystem;
    moduleSet = "nixos";
    platform = "linux";
    defaultArch = "x86_64";
  };
}
