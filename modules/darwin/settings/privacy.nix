{
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = true;
  };

  system.defaults.CustomUserPreferences."com.apple.AdLib" = {
    allowApplePersonalizedAdvertising = false;
  };
}
