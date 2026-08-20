{
  nix = {
    channel.enable = false;

    settings = {
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
      ];

      accept-flake-config = false;
      auto-allocate-uids = true;
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      warn-dirty = false;
    };
  };

  system.checks.verifyBuildUsers = false;
}
