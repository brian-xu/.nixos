{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ../../modules/security/fprintd-lid.nix ];

  # nixos-hardware framework-13-7040-amd is loaded at flake level; this module
  # adds Framework-specific overrides not covered by nixos-hardware.
  boot.kernelPackages = pkgs.linuxPackagesFor (
    pkgs.linux_6_12.override {
      argsOverride = rec {
        src = pkgs.fetchurl {
          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
          sha256 = "sha256-zBKnZEtM754GYnsp3odT4is9B2cDqbUr6EJj4FyLmDA=";
        };
        version = "6.12.87";
        modDirVersion = "6.12.87";
      };
    }
  );

  # Switch Pixart touchpad from interrupt to polling to reduce ~157 IRQ/s storm
  boot.kernelParams = [ "i2c_hid_acpi.polling_mode=1" ];

  hardware.sensor.iio.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.enableRedistributableFirmware = true;
  hardware.fw-fanctrl.enable = true;
  hardware.fw-fanctrl.config.defaultStrategy = "agile";

  environment.systemPackages = with pkgs; [
    framework-tool
    framework-tool-tui
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
    ];
  };
  security.pam.services.login.fprintAuth = true;
  security.pam.services.login.rules.auth.fprintd.settings.timeout = 30;
  # security.pam.services.sddm.fprintAuth = true;
  # security.pam.services.kde.fprintAuth = lib.mkForce true;

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="disabled"
  '';
}
