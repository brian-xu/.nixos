{ pkgs, ... }:
{
  imports = [ ./session.nix ];

  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # Drop COSMIC apps
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-store
    cosmic-term
    cosmic-screenshot
    cosmic-player
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    kdePackages.gwenview
    pwvucontrol
  ];

  # Enable global clipboard
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";

  # Backlight control for niri
  services.udev.packages = with pkgs; [
    brightnessctl
  ];
  services.system76-scheduler.enable = true;
  hardware.system76.power-daemon.enable = true;
}
