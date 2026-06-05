{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.allExceptThisDefault ./.;

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

  # GNOME desktop on Wayland, GDM greeter
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # PaperWM scrollable-tiling GNOME Shell extension (installed system-wide so
  # gnome-shell discovers it; enabled + configured per-user via dconf).
  environment.systemPackages = [ pkgs.gnomeExtensions.paperwm ];

  # Trim GNOME apps we don't use (firefox/thunderbird/dolphin cover these).
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-console
    epiphany # web browser
    geary # email
    gnome-music
    totem # video player
    gnome-maps
    gnome-contacts
    yelp # help viewer
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "gnome" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
}
