{ lib, ... }:

let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in
{
  options.me = {
    mainUser = mkOption {
      type = str;
      default = "ferry";
    };
  };
}
