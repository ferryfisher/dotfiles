{
  # using determinate-nix
  nix.enable = false;

  environment = {
    variables = {
      DETSYS_IDS_TELEMETRY = "disabled";
      NIX_SENTRY_ENDPOINT = "";
    };

    etc."determinate/config.json".text = builtins.toJSON {
      telemetry.sentry.endpoint = null;
    };

    etc."nix/nix.custom.conf".text = ''
      # Managed declaratively.
      experimental-features = auto-allocate-uids flakes nix-command

      accept-flake-config = false
      allow-import-from-derivation = false
      auto-allocate-uids = true
      keep-going = true
      use-xdg-base-directories = true
      warn-dirty = false
    '';
  };
}
