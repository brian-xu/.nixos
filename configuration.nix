# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  lib = pkgs.lib;
  nixos-hardware = builtins.fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
  sops-nix = builtins.fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
in

{
  imports =
    [
      (import "${nixos-hardware}/framework/13-inch/7040-amd")
      (import "${home-manager}/nixos")
      "${sops-nix}/modules/sops"
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.sensor.iio.enable = false;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable support for Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brian = {
    isNormalUser = true;
    description = "Brian";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # sops secrets — uncomment after running bootstrap sequence in README
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/etc/age/keys.txt";  # personal break-glass key — restore from Bitwarden
  sops.secrets.ssh_id_ed25519 = {
    path = "/home/brian/.ssh/id_ed25519";
    owner = "brian";
    mode = "600";
  };
  sops.secrets.racknerd = {
    path = "/home/brian/.ssh/racknerd";
    owner = "brian";
    mode = "600";
  };
  sops.secrets.google_compute_engine = {
    path = "/home/brian/.ssh/google_compute_engine";
    owner = "brian";
    mode = "600";
  };
  sops.secrets.brian-1 = {
    path = "/home/brian/.ssh/brian-1.pem";
    owner = "brian";
    mode = "600";
  };
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.brian = {pkgs, ...}: {
    programs.bash.enable = true;
    home.packages = with pkgs; [
      # util
      sops
      age
      ssh-to-age
      pkg-config
      tailscale
      framework-tool
      fw-fanctrl
      albert
      power-profiles-daemon
      # desktop apps
      bitwarden-desktop
      floorp-bin
      slack
      discord
      obsidian
      termsonic
      thunderbird
      # coding
      git
      micromamba
      uv
      ruff
      alacritty
      vscode-fhs
      claude-code
    ];

    home.stateVersion = "25.11"; # Please read the comment before changing.
  };

  # Install firefox.
  # programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  kdePackages.bluez-qt
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # OpenSSH — kept disabled for external access; host key at /etc/ssh/ssh_host_ed25519_key is used by sops-nix
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  services.tailscale.enable = true;

    # Enable auto-cpufreq service
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  fonts.packages = with pkgs; [
    maple-mono.NF
    maple-mono.Normal-NF
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.roboto-mono
  ];

  # Enable update of the firmware through Linux
  services.fwupd.enable = true;

  # Enable redistributable firmware
  hardware.enableRedistributableFirmware = true;

  # Enable the bolt protocol for thunderbolt docks
  services.hardware.bolt.enable = true;

  # Use zsh as the default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
