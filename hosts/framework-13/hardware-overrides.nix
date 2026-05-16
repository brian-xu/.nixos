{
  pkgs,
  lib,
  ...
}:
{
  # nixos-hardware framework-13-7040-amd is loaded at flake level; this module
  # adds Framework-specific overrides not covered by nixos-hardware.

  # Switch Pixart touchpad from interrupt to polling to reduce ~157 IRQ/s storm
  boot.kernelParams = [ "i2c_hid_acpi.polling_mode=1" ];

  hardware.sensor.iio.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    framework-tool
    fw-fanctrl
  ];

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sddm.fprintAuth = true;
  security.pam.services.kde.fprintAuth = lib.mkForce true;

  security.pam.services.login.rules.auth.fprintd.settings.timeout = 5;
  security.pam.services.sddm.rules.auth.fprintd.settings.timeout = 5;
  security.pam.services.kde.rules.auth.fprintd.settings.timeout = 5;

  services.fwupd.enable = true;

  services.hardware.bolt.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="disabled"
  '';
}
