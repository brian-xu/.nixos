{
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 4;
    criticalPowerAction = "PowerOff";
  };

  services.tlp.enable = false;
  services.power-profiles-daemon.enable = false;
}
