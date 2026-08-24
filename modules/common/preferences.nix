{ lib, ... }:

let
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr str;

  mkPreference =
    choice:
    {
      default ? null,
      description ? "the system's ${choice} preference.",
      type ? str,
      ...
    }:
    mkOption {
      inherit default description;
      type = nullOr type;
    };
in
{
  options.preferences = builtins.mapAttrs mkPreference {
    editor = { };
    manpager = { };
    terminal = {
      default = "ghostty";
    };
  };
}
