{ config, lib, ... }:

{
  system.primaryUser = config.me.mainUser;
  system.stateVersion = lib.mkDefault 7;
}
