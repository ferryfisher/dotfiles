{ config, pkgs, ... }:

let
  mainUser = config.me.mainUser;
in
{
  users.users.${mainUser} = {
    home = "/Users/${mainUser}";
    shell = pkgs.bashInteractive;
  };
}
