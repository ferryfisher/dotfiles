{ pkgs, ... }:

{
  nix = {
    channel.enable = false;
    package = pkgs.nixVersions.latest;

    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];

      accept-flake-config = false;
      allow-import-from-derivation = false;
      keep-going = true;
      sandbox = true;
      use-xdg-base-directories = true;
      warn-dirty = false;
    };
  };
}
