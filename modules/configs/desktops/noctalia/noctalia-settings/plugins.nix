{
  programs.noctalia-shell.settings.plugins = {
    autoUpdate = false;
    notifyUpdates = true;
    sources = [
      {
        enabled = true;
        name = "Official Noctalia Plugins";
        url = "https://github.com/noctalia-dev/noctalia-plugins";
      }
      {
        enabled = true;
        name = "My Custom Plugins";
        url = "https://github.com/brian-xu/fw-fanctrl-qml";
      }
    ];
    states = {
      "fb27f8:fw-fanctrl" = {
        enabled = true;
        sourceUrl = "https://github.com/brian-xu/fw-fanctrl-qml";
      };
      polkit-agent = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
    };
  };
}
