{ inputs, pkgs, ... }:

{
  environment = {
    systemPackages = [
      inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    variables = {
      TACK_NO_TOKEN = "1";
    };
  };
}
