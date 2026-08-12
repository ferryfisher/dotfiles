{ pkgs, ... }:

{
  users.users.ferry = {
    home = "/Users/ferry";
    shell = pkgs.bashInteractive;
  };
}
