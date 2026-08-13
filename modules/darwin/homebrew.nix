{ inputs, config, ... }:

{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    mutableTaps = false;
    package = inputs.homebrew;
    user = "ferry";

    taps = {
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-core" = inputs.homebrew-core;
    };
  };

  homebrew = {
    enable = true;

    caskArgs.require_sha = true;
    global.autoUpdate = false;

    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      cleanup = "zap";
      upgrade = true;

      extraEnv = {
        HOMEBREW_NO_ANALYTICS = "1";
        HOMEBREW_NO_ENV_HINTS = "1";
        HOMEBREW_NO_INSECURE_REDIRECT = "1";
      };
    };

    casks = [
      "firefox"
      "ghostty"
      "hammerspoon"
    ];
  };
}
