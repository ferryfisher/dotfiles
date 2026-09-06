{
  # using determinate-nix
  nix.enable = false;

  environment.etc."nix/nix.custom.conf".text = ''
    # Managed declaratively.
    experimental-features = auto-allocate-uids flakes nix-command

    accept-flake-config = false
    allow-import-from-derivation = false
    auto-allocate-uids = true
    keep-going = true
    use-xdg-base-directories = true
    warn-dirty = false
  '';
}
