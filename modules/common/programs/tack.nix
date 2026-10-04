{ inputs, pkgs, ... }:

{
  environment = {
    systemPackages = [
      inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    variables = {
      TACK_NIX_CONF_TOKENS = "0";
    };
  };
}
