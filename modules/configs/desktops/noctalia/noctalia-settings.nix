{
  programs.noctalia-shell.settings = {
    bar = {
      barType = "floating";
      position = "top";
      density = "comfortable";
      showCapsule = true;
      widgets = {
        left = [
          { id = "Launcher"; }
          {
            id = "Clock";
            formatHorizontal = "HH:mm ddd, MMM dd";
            formatVertical = "HH mm";
            useMonospacedFont = true;
            usePrimaryColor = false;
          }
          { id = "SystemMonitor"; }
          { id = "ActiveWindow"; }
          {
            id = "MediaMini";
            showAlbumArt = false;
          }
        ];
        center = [
          {
            id = "Workspace";
            hideUnoccupied = false;
            labelMode = "index";
          }
        ];
        right = [
          { id = "Tray"; }
          { id = "Battery"; }
          { id = "NotificationHistory"; }
          { id = "Volume"; }
          {
            id = "ControlCenter";
            useDistroLogo = true;
            icon = "noctalia";
            enableColorization = true;
          }
        ];
      };
    };

    general = {
      avatarImage = "/home/brian/.face";
      autoStartAuth = true;
      allowPasswordWithFprintd = true;
    };

    colorSchemes = {
      useWallpaperColors = true;
      generationMethod = "tonal-spot";
    };

    templates = {
      activeTemplates = [
        "alacritty"
        "cava"
        "gtk"
        "niri"
        "qt"
        "yazi"
      ];
    };

    location = {
      name = "Providence, US";
      useFahrenheit = true;
      analogClockInCalendar = true;
    };

    dock = {
      onlySameOutput = true;
    };

    controlCenter = {
      cards = [
        {
          enabled = true;
          id = "profile-card";
        }
        {
          enabled = true;
          id = "shortcuts-card";
        }
        {
          enabled = true;
          id = "audio-card";
        }
        {
          enabled = true;
          id = "brightness-card";
        }
        {
          enabled = false;
          id = "weather-card";
        }
        {
          enabled = true;
          id = "media-sysmon-card";
        }
      ];
    };

    appLauncher = {
      enableClipboardHistory = true;
    };

    sessionMenu = {
      countdownDuration = 5000;
    };

    idle = {
      enabled = true;
    };

    nightLight = {
      enabled = true;
    };
  };
}
