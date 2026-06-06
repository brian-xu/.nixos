# Adapted from https://github.com/linuxmobile/shin/tree/niri_cosmic_OLD

{
  pkgs,
  lib,
  ...
}:
let
  start-cosmic-niri = pkgs.writeShellScriptBin "start-cosmic-niri" ''
    set -e
    export PATH=${
      lib.makeBinPath [
        pkgs.systemd
        pkgs.dbus
        pkgs.cosmic-session
        pkgs.niri
        pkgs.bash
        pkgs.coreutils
      ]
    }:$PATH

    # From: https://people.debian.org/~mpitt/systemd.conf-2016-graphical-session.pdf
    # robustness: if the previous graphical session left some failed units,
    # reset them so that they don't break this startup
    if command -v systemctl >/dev/null; then
      for unit in $(systemctl --user --no-legend --state=failed --plain list-units | cut -f1 -d' '); do
        partof="$(systemctl --user show -p PartOf --value "$unit")"
        for target in cosmic-session.target graphical-session.target; do
          if [ "$partof" = "$target" ]; then
            systemctl --user reset-failed "$unit"
            break
          fi
        done
      done
    fi

    # use the user's preferred shell to acquire environment variables
    # see: https://github.com/pop-os/cosmic-session/issues/23
    if [ -n "''${SHELL:-}" ]; then
      # --in-login-shell: our flag to indicate that we don't need to recurse any further
      if [ "''${1:-}" != "--in-login-shell" ]; then
        # `exec -l`: like `login`, prefixes $SHELL with a hyphen to start a login shell
        exec bash -c "exec -l ${"'"}''${SHELL}' -c ${"'"}''${0} --in-login-shell'"
      fi
    fi

    export XDG_CURRENT_DESKTOP="''${XDG_CURRENT_DESKTOP:=niri}"
    export XDG_SESSION_TYPE="''${XDG_SESSION_TYPE:=wayland}"
    export XCURSOR_THEME="''${XCURSOR_THEME:=Cosmic}"
    export _JAVA_AWT_WM_NONREPARENTING=1
    # NB: do NOT set GDK_BACKEND globally — niri's docs warn it breaks the
    # screencast portal (xdg-desktop-portal-gnome is a GTK app).
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM="wayland;xcb"
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_ENABLE_HIGHDPI_SCALING=1

    if command -v systemctl >/dev/null; then
      # set environment variables for new units started by user service manager
      systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
    fi

    # Run cosmic-session, passing `niri` as the compositor to launch.
    # `--session` is required: niri is our main compositor instance, and the
    # flag makes niri (a) import its environment globally to systemd & D-Bus
    # and (b) run its D-Bus services. Without it, the GNOME screencast portal
    # never sees niri's org.gnome.Mutter.ScreenCast/ServiceChannel (so Firefox/
    # Discord screen sharing fails), and apps launched outside niri's child
    # tree (e.g. from the COSMIC launcher) miss DISPLAY/NIXOS_OZONE_WL and break.
    # cosmic-session forwards trailing args to the compositor it execs.
    if [ -z "''${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
      exec dbus-run-session -- cosmic-session niri --session
    else
      exec cosmic-session niri --session
    fi
  '';

  session = pkgs.writeTextFile {
    name = "cosmic-on-niri-session";
    destination = "/share/wayland-sessions/COSMIC-on-niri.desktop";
    text = ''
      [Desktop Entry]
      Name=COSMIC on niri
      Comment=COSMIC desktop using the niri compositor
      Type=Application
      DesktopNames=niri
      Exec=${start-cosmic-niri}/bin/start-cosmic-niri
    '';
  };
in
{
  services.displayManager.sessionPackages = [
    (session.overrideAttrs (_: {
      passthru.providedSessions = [ "COSMIC-on-niri" ];
    }))
  ];
}
