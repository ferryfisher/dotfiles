{
  nix = {
    channel.enable = false;

    settings = {
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
      ];

      auto-allocate-uids = true;
      auto-optimise-store = true;
      use-xdg-base-directories = true;
    };
  };

  system.checks.verifyBuildUsers = false;
}
