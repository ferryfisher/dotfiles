{
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;

    settings = {
      global = {
        strict_env = true;
      };
    };
  };
}
