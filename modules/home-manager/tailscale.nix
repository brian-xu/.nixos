{
  pkgs,
  ...
}:
{
  systemd.user.services.tailscale-systray = {
    Unit = {
      Description = "Tailscale systray";
      Wants = [ "network-online.target" ];
      After = [
        "network-online.target"
        "tailscaled.service"
        "graphical-session.target"
      ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.tailscale}/bin/tailscale systray";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
