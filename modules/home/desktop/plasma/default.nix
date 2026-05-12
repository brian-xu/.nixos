{ config, pkgs, ... }:
{
  programs.plasma.enable = true;

  programs.plasma.krunner.shortcuts.launch = "Ctrl+Space";

  # KWin compositor: OpenGL 3.1 core profile + nearest-neighbor scaling
  programs.plasma.configFile.kwinrc.Compositing.GLCore = true;
  programs.plasma.configFile.kwinrc.Compositing.GLTextureFilter = 0;

  programs.plasma.configFile.kwinrc.NightColor.Active = true;

  programs.plasma.configFile.kwinrc.TabSwitcher.ActivitiesMode = 1;
  programs.plasma.configFile.kwinrc.TabSwitcher.DesktopMode = 1;
  programs.plasma.configFile.kwinrc.TabSwitcher.ScreenMode = 1;

  programs.plasma.configFile.kdeglobals.General.TerminalApplication = "alacritty";
  programs.plasma.configFile.kdeglobals.General.TerminalService = "Alacritty.desktop";

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
