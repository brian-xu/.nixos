{
  imports = [
    ../../modules/programs
    ../../modules/services
    ../../modules/security
    ../../modules/desktops/cosmic
  ];

  services.fprintd.enable = true;
  services.fprintd.lid = {
    authSkipLidClose = true;
    path = "/proc/acpi/button/lid/LID0/state";
    pamServices = [
      "login"
      "sudo"
      "su"
      "polkit-1"
      "cosmic-greeter"
    ];
  };
  security.pam.services.login.fprintAuth = true;
  security.pam.services.login.rules.auth.fprintd.settings.timeout = 30;
}
