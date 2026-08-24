{ inputs', ... }:

{
  environment = {
    systemPackages = [
      inputs'.neovim-nightly-overlay.packages.neovim
    ];
  };
}
