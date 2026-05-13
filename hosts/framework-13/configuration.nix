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
    ../../modules/services
    ../../modules/services/power-management.nix
    ../../modules/security
    ../../homes/brian/ssh-keys.nix
  ];
}
