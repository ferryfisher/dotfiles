{ config, pkgs, ... }:

let
  inherit (config.me) mainUser;
in
{
  users.users.${mainUser} = {
    home = "/Users/${mainUser}";
    shell = pkgs.bashInteractive;
  };
}
