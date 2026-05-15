{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (callPackage ../../../../pkgs/krohnkite.nix { })
  ];

  programs.plasma.enable = true;
  programs.plasma.overrideConfig = true;

  programs.plasma.workspace.colorScheme = "BreezeDark";

  programs.plasma.krunner.shortcuts.launch = "Ctrl+Space";
  programs.plasma.configFile.krunnerrc.General.FreeFloating = true;

  programs.plasma.configFile.kwinrc = {
    Compositing.GLCore = true;
    Compositing.GLTextureFilter = 0;

    NightColor.Active = true;

    TabSwitcher.ActivitiesMode = 1;
    TabSwitcher.DesktopMode = 1;
    TabSwitcher.ScreenMode = 1;

    Plugins.krohnkiteEnabled = true;
    Script-krohnkite = {
      enableMonocleLayout = false;
      enableSpiralLayout = true;
      enableSpreadLayout = false;
      enableStairLayout = false;
      enableTileLayout = false;
      floatingTitle = "Picture in picture";
      layoutPerActivity = true;
      layoutPerDesktop = true;
      noTileBorder = false;
      screenDefaultLayout = ":spiral";
      spiralLayoutOrder = 1;
      tileLayoutOrder = 4;
    };
  };

  programs.plasma.configFile.kdeglobals.General.TerminalApplication = "alacritty";
  programs.plasma.configFile.kdeglobals.General.TerminalService = "Alacritty.desktop";

  # Set minimum window size to 0x0 for krohnkite
  programs.plasma.window-rules = [
    {
      description = "Minimum size";
      apply.minsize = {
        apply = "force";
        value = "0,0";
      };
      match.window-types = [
        "normal"
        "dialog"
      ];
    }
  ];

  programs.plasma.panels = [
    {
      location = "bottom";
      height = 40;
    }
  ];

  programs.plasma.powerdevil = {
    AC.whenLaptopLidClosed = "doNothing";
  };

  programs.plasma.input.touchpads = [
    {
      name = "PIXA3854:00 093A:0274 Touchpad";
      vendorId = "093a";
      productId = "0274";
      naturalScroll = true;
    }
  ];
}
