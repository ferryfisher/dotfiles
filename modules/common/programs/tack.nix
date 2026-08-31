{ pkgs, ... }:

{
  environment = {
    systemPackages = [ pkgs.tack ];
    variables = {
      TACK_NIX_CONF_TOKENS = "0";
      GITHUB_TOKEN = "0"; # silences tack token warning
    };
  };
}
