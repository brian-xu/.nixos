{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  hardware.enableRedistributableFirmware = true;
  users.users.brian = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "install";
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "brian"
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://brian-xu.cachix.org"
    "https://niri.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gwWVrUeUlo4vQwJGtH0hFEEwPiW7g="
    "brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4="
    "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
  ];
  system.stateVersion = "26.05";
}
