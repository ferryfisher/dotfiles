{ lib, ... }:

let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in
{
  options.me = {
    mainUser = mkOption {
      default = "ferry";
      description = "Main user's username";
      type = str;
    };
  };
}
