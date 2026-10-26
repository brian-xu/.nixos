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
  boot.kernelModules = [ "kvm-amd" ];

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

  # 26.05 enables systemd stage 1 by default. Upstream systemd's
  # 99-systemd.rules marks dm-crypt devices as SYSTEMD_READY=0 when udev
  # can't identify a filesystem superblock on the mapped device, which is
  # common for LUKS+btrfs. sysroot.mount then times out waiting for
  # dev-mapper-crypted.device and the boot cascades into
  # "Dependency failed for Find NixOS closure" (nixpkgs#527478).
  # Mark encrypted mapper devices ready so the root mount can proceed.
  boot.initrd.services.udev.packages = [
    (pkgs.writeTextDir "etc/udev/rules.d/A0-luks-ready.rules" ''
      SUBSYSTEM=="block", ENV{DM_UUID}=="CRYPT-*", ENV{SYSTEMD_READY}="1"
    '')
  ];
}
