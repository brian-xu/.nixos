{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  programs.niri.enable = true;

  services.displayManager.ly.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.tailscale.enable = true;
}
