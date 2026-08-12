{ lib, ... }:

{
  system.primaryUser = "ferry";
  system.stateVersion = lib.mkDefault 7;
}
