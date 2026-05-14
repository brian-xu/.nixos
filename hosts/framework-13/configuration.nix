{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-overrides.nix
    ../../modules/programs
    ../../modules/configs/desktops/plasma
    ../../modules/services/plasma.nix
    ../../modules/services/power-management.nix
    ../../modules/security
    ../../homes/brian/ssh-keys.nix
  ];
}
