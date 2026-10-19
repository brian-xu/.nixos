{ lib, ... }:
{
  # Install-time variant of the framework host.
  #
  # Used as the disko-install target so the toplevel closure fits in the
  # installer ISO's RAM-backed /nix store. The full configuration is applied
  # afterwards with `nixos-rebuild switch --flake .#framework` from the booted
  # system, where /nix lives on disk.
  #
  # The flake host for this variant omits home-manager, COSMIC, and the sops
  # secrets modules entirely (activation would need the age key, which is only
  # staged onto the target disk by disko-install --extra-files). This module
  # only overrides the heavier settings from hardware-overrides.nix.
  services.fprintd.enable = lib.mkForce false;
  hardware.fw-fanctrl.enable = lib.mkForce false;
  environment.systemPackages = lib.mkForce [ ];
}
