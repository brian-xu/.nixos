{ config, pkgs, lib, ... }:

let
  nixos-hardware = builtins.fetchTarball "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz";
in

{
  imports = [
    "${nixos-hardware}/framework/13-inch/7040-amd"
  ];

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

  services.fwupd.enable = true;

  # Enable the bolt protocol for thunderbolt docks
  services.hardware.bolt.enable = true;
}
