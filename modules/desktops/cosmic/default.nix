{
  imports = [ ./session.nix ];

  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # Let clipboard managers (cliphist / wl-clip-persist) read the clipboard
  # under COSMIC's compositor stack.
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
}
