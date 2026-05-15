{
  programs.noctalia-shell.settings.bar = {
    barType = "floating";
    position = "top";
    monitors = [ ];
    density = "comfortable";
    showOutline = false;
    showCapsule = true;
    capsuleOpacity = 1;
    capsuleColorKey = "none";
    widgetSpacing = 6;
    contentPadding = 2;
    fontScale = 1;
    enableExclusionZoneInset = true;
    backgroundOpacity = 0.93;
    useSeparateOpacity = false;
    marginVertical = 4;
    marginHorizontal = 4;
    frameThickness = 8;
    frameRadius = 12;
    outerCorners = true;
    hideOnOverview = false;
    displayMode = "always_visible";
    autoHideDelay = 500;
    autoShowDelay = 150;
    showOnWorkspaceSwitch = true;
    widgets = {
      left = [
        {
          colorizeSystemIcon = "none";
          colorizeSystemText = "none";
          customIconPath = "";
          enableColorization = false;
          icon = "rocket";
          iconColor = "none";
          id = "Launcher";
          useDistroLogo = false;
        }
        {
          clockColor = "none";
          customFont = "";
          formatHorizontal = "HH:mm ddd; MMM dd";
          formatVertical = "HH mm";
          id = "Clock";
          tooltipFormat = "HH:mm ddd; MMM dd";
          useCustomFont = false;
        }
        {
          compactMode = true;
          diskPath = "/";
          iconColor = "none";
          id = "SystemMonitor";
          showCpuCores = false;
          showCpuFreq = false;
          showCpuTemp = true;
          showCpuUsage = true;
          showDiskAvailable = false;
          showDiskUsage = false;
          showDiskUsageAsPercent = false;
          showGpuTemp = false;
          showLoadAverage = false;
          showMemoryAsPercent = false;
          showMemoryUsage = true;
          showNetworkStats = false;
          showSwapUsage = false;
          textColor = "none";
          useMonospaceFont = true;
          usePadding = false;
        }
        {
          colorizeIcons = false;
          hideMode = "hidden";
          id = "ActiveWindow";
          maxWidth = 145;
          scrollingMode = "hover";
          showIcon = true;
          showText = true;
          textColor = "none";
          useFixedWidth = false;
        }
        {
          compactMode = false;
          hideMode = "hidden";
          hideWhenIdle = false;
          id = "MediaMini";
          maxWidth = 145;
          panelShowAlbumArt = true;
          scrollingMode = "hover";
          showAlbumArt = false;
          showArtistFirst = true;
          showProgressRing = true;
          showVisualizer = false;
          textColor = "none";
          useFixedWidth = false;
          visualizerType = "linear";
        }
      ];
      center = [
        {
          characterCount = 2;
          colorizeIcons = false;
          emptyColor = "secondary";
          enableScrollWheel = true;
          focusedColor = "primary";
          followFocusedScreen = false;
          fontWeight = "bold";
          groupedBorderOpacity = 1;
          hideUnoccupied = false;
          iconScale = 0.8;
          id = "Workspace";
          labelMode = "index";
          occupiedColor = "secondary";
          pillSize = 0.6;
          showApplications = false;
          showApplicationsHover = false;
          showBadge = true;
          showLabelsOnlyWhenOccupied = true;
          unfocusedIconsOpacity = 1;
        }
      ];
      right = [
        {
          blacklist = [ ];
          chevronColor = "none";
          colorizeIcons = false;
          drawerEnabled = true;
          hidePassive = false;
          id = "Tray";
          pinned = [ ];
        }
        {
          deviceNativePath = "__default__";
          displayMode = "graphic-clean";
          hideIfIdle = false;
          hideIfNotDetected = true;
          id = "Battery";
          showNoctaliaPerformance = false;
          showPowerProfiles = false;
        }
        {
          hideWhenZero = false;
          hideWhenZeroUnread = false;
          iconColor = "none";
          id = "NotificationHistory";
          showUnreadBadge = true;
          unreadBadgeColor = "primary";
        }
        {
          displayMode = "onhover";
          iconColor = "none";
          id = "Volume";
          middleClickCommand = "pwvucontrol || pavucontrol";
          textColor = "none";
        }
        {
          colorizeDistroLogo = false;
          colorizeSystemIcon = "none";
          colorizeSystemText = "none";
          customIconPath = "";
          enableColorization = true;
          icon = "noctalia";
          id = "ControlCenter";
          useDistroLogo = true;
        }
      ];
    };
    mouseWheelAction = "none";
    reverseScroll = false;
    mouseWheelWrap = true;
    middleClickAction = "none";
    middleClickFollowMouse = false;
    middleClickCommand = "";
    rightClickAction = "controlCenter";
    rightClickFollowMouse = true;
    rightClickCommand = "";
    screenOverrides = [ ];
  };
}
