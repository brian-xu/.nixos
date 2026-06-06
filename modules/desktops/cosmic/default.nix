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
  ];

  # Enable global clipboard
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";

  # Backlight control for niri
  environment.systemPackages = [ pkgs.brightnessctl ];
  services.udev.packages = [ pkgs.brightnessctl ];
  services.system76-scheduler.enable = true;
}
