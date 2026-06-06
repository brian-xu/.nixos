{
  # XDG_CURRENT_DESKTOP / XDG_SESSION_TYPE are set by the COSMIC-on-niri
  # session script (session.nix), so they are intentionally not overridden here.
  programs.niri.settings.environment = {
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    # xwayland-satellite display for X11 clients
    DISPLAY = ":0";
  };
}
