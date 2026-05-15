{
  programs.noctalia-shell.settings.templates = {
    activeTemplates = [
      "alacritty"
      "cava"
      "gtk"
      "niri"
      "qt"
      "yazi"
      {
        enabled = true;
        id = "alacritty";
      }
      {
        enabled = true;
        id = "cava";
      }
      {
        enabled = true;
        id = "gtk";
      }
      {
        enabled = true;
        id = "niri";
      }
      {
        enabled = true;
        id = "qt";
      }
      {
        enabled = true;
        id = "niri";
      }
    ];
    enableUserTheming = false;
  };
}
