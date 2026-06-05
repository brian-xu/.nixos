{
  pkgs,
  ...
}:
let
  wallpaper = "${pkgs.nixos-artwork.wallpapers.nineish}/share/backgrounds/nixos/nix-wallpaper-nineish.png";
in
{
  home.packages = with pkgs; [
    # daemons / commands
    udiskie
    pwvucontrol
    wl-clipboard
    # desktop apps
    kdePackages.okular
    kdePackages.gwenview
    gedit
    # file manager (nautilus removed in favour of dolphin)
    kdePackages.qtsvg
    kdePackages.dolphin # This is the actual dolphin package
    kdePackages.kio # needed since 25.11
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)
  ];

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
    };
  };

  dconf.settings = {
    # --- enable PaperWM ---
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "paperwm@paperwm.github.com" ];
    };

    # --- desktop background (keep the nineish wallpaper) ---
    "org/gnome/desktop/background" = {
      picture-uri = "file://${wallpaper}";
      picture-uri-dark = "file://${wallpaper}";
      picture-options = "zoom";
    };

    # --- PaperWM layout (mirrors the old niri layout) ---
    "org/gnome/shell/extensions/paperwm" = {
      window-gap = 16; # niri gaps = 16
      horizontal-margin = 16;
      vertical-margin = 16;
      vertical-margin-bottom = 16;
      # niri preset-column-widths: 1/3, 1/2, 2/3 (cycled with super+r)
      cycle-width-steps = [
        0.33333
        0.5
        0.66667
      ];
      use-default-background = true;
    };

    # --- PaperWM keybindings (mirror niri binds) ---
    "org/gnome/shell/extensions/paperwm/keybindings" = {
      toggle-maximize-width = [ "<Super>f" ]; # niri expand-column-to-available-width
      toggle-scratch-window = [ "<Super>t" ]; # niri toggle-window-floating
      take-window = [ ]; # clear default <Super>t

      resize-w-dec = [ "<Super>s" ]; # niri set-column-width -34%
      resize-w-inc = [ "<Super>d" ]; # niri set-column-width +34%

      switch-left = [ "<Super>Left" ]; # niri focus-column-left
      switch-right = [ "<Super>Right" ]; # niri focus-column-right
      move-left = [ "<Super><Shift>Left" ]; # niri move-column-left
      move-right = [ "<Super><Shift>Right" ]; # niri move-column-right

      switch-up-workspace = [ "<Super>Up" ]; # niri focus-workspace-up
      switch-down-workspace = [ "<Super>Down" ]; # niri focus-workspace-down
      move-up-workspace = [ "<Super><Shift>Up" ]; # niri move-column-to-workspace-up
      move-down-workspace = [ "<Super><Shift>Down" ]; # niri move-column-to-workspace-down

      new-window = [ "<Super>n" ]; # drop default <Super>Return (freed for terminal)
      close-window = [ ]; # use GNOME's wm "close" (<Super>q) instead

      # clear defaults that would collide with the binds above
      switch-up = [ ];
      switch-down = [ ];
      switch-monitor-left = [ ];
      switch-monitor-right = [ ];
      switch-monitor-above = [ ];
      switch-monitor-below = [ ];
    };

    # --- GNOME window-manager keybindings ---
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ]; # niri close-window
      switch-input-source = [ ]; # free <Super>space for the launcher
      switch-input-source-backward = [ ];
    };
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy"; # niri focus-follows-mouse
    };

    # --- launcher / lock (niri super+Space launcher, super+L screen-lock) ---
    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ "<Super>space" ];
    };

    # --- terminal: super+Return -> alacritty (niri spawn) ---
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = [ "<Super>l" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "alacritty";
      binding = "<Super>Return";
    };

    # --- touchpad / input (mirror niri input.touchpad) ---
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
      click-method = "areas"; # niri click-method = button-areas
      disable-while-typing = true; # niri dwt
      middle-click-emulation = true; # niri middle-emulation
      tap-button-map = "lrm"; # niri tap-button-map = left-right-middle
      accel-profile = "adaptive"; # niri accel-profile = adaptive
      send-events = "enabled";
    };
  };
}
