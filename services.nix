{ config, pkgs, ... }:

{
  # X11 windowing system — disabled, using Wayland only
  services.xserver.enable = false;

  # KDE Plasma via Wayland
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.tailscale.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
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
  # services.auto-cpufreq = {
  #   enable = true;
  #   settings = {
  #     battery = {
  #       governor = "powersave";
  #       turbo = "never";
  #     };
  #     charger = {
  #       governor = "performance";
  #       turbo = "auto";
  #     };
  #   };
  # };
}
