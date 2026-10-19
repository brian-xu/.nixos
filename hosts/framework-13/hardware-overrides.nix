{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  # nixos-hardware framework-13-7040-amd is loaded at flake level; this module
  # adds Framework-specific overrides not covered by nixos-hardware.
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="disabled"
  '';
}
