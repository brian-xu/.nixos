{
  imports = [
    ./disko.nix
    ./hardware-overrides.nix
    ../../modules/programs
    ../../modules/services
    ../../modules/security
    ../../modules/desktops/cosmic
  ];
}
