{ config, ... }:

let
  inherit (config) preferences;
in
{
  environment.variables = with preferences; {
    EDITOR = editor;
    MANPAGER = manpager;
    TERMINAL = terminal;
  };
}
