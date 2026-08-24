{ lib, ... }:

let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in
{
  options.me = builtins.mapAttrs (_: mkOption) {
    mainUser = {
      default = "ferry";
      description = "Main user's username";
      type = str;
    };
  };
}
