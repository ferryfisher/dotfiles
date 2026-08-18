{ config, ... }:

{
  system.primaryUser = config.me.mainUser;
  system.stateVersion = 7;
}
