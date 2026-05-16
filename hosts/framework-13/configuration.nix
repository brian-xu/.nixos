{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-overrides.nix
    ../../modules/programs
    ../../modules/services
    ../../modules/services/power-management.nix
    ../../modules/services/lid.nix
    ../../modules/security
    ../../homes/brian/ssh-keys.nix
  ];

  # Desktop environments
  programs.niri.enable = true;
  # services.desktopManager.plasma6.enable = true;
}
