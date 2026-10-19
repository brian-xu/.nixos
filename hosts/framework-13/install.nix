{ lib, ... }:
{
  users.users.brian.initialPassword = "install";

  services.fprintd.enable = lib.mkForce false;
  hardware.fw-fanctrl.enable = lib.mkForce false;
  environment.systemPackages = lib.mkForce [ ];
}
