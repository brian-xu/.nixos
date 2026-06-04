{
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 4;
    criticalPowerAction = "PowerOff";
  };

  services.tlp = {
    enable = true;
    settings = {
      # amd-pstate-epp requires powersave governor; schedutil is ignored by this driver
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy Performance Preference — the main knob for AMD P-state EPP
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Disable turbo boost on battery (biggest single-battery-life gain)
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # ACPI platform profile (Framework 13 supports low-power)
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Wi-Fi power save (5 = PS-Poll; reduces mt7921e wakeups)
      WIFI_PWR_ON_AC = 3;
      WIFI_PWR_ON_BAT = 5;
    };
  };
  services.power-profiles-daemon.enable = false;
}
