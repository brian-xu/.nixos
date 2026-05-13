{ inputs, config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/nixos/hardware/framework-13
    ../../../modules/nixos/programs
    ../../../modules/nixos/services
    ../../../modules/nixos/security
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

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

  users.users.brian = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  # sops secrets
  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
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

  system.stateVersion = "25.11"; # Did you read the comment?
}
