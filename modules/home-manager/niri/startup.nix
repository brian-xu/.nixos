{
  pkgs,
  ...
}:
{
  programs.niri.settings.spawn-at-startup = [
    {
      command = [ "${pkgs.cosmic-ext-alternative-startup}/bin/cosmic-ext-alternative-startup" ];
    }
    { command = [ "xwayland-satellite" ]; }
    {
      command = [
        "${pkgs.swayidle}/bin/swayidle"
        "-w"
        # Screen off after 15 min idle, back on when activity resumes.
        "timeout"
        "900"
        "niri msg action power-off-monitors"
        "resume"
        "niri msg action power-on-monitors"
        # On battery: suspend after 15 min idle.
        "timeout"
        "900"
        "grep -q 1 /sys/class/power_supply/ACAD/online || systemctl suspend"
        # On AC: suspend after 30 min idle.
        "timeout"
        "1800"
        "grep -q 1 /sys/class/power_supply/ACAD/online && systemctl suspend"
        "before-sleep"
        "loginctl lock-session"
      ];
    }
  ];
}
