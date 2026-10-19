{
  # Full host: desktop + home-manager modules layered on the shared base
  # (configuration.nix). The install variant (framework-install) uses the base
  # plus install.nix instead, without these.
  imports = [
    ../../modules/programs
    ../../modules/services
    ../../modules/security
    ../../modules/desktops/cosmic
  ];
}
