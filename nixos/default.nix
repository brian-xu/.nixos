{
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

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
      "video" # backlight write access (brightnessctl udev rules)
    ];
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  nix = {
    settings = {
      trusted-users = [
        "root"
        "brian"
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://cache.nixos.org"
        "https://brian-xu.cachix.org"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      extra-trusted-public-keys = [
        "brian-xu.cachix.org-1:Wc29LaxB/t3YjkXEDGMAcnBKYj8YqQl9pPs48nDcro4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
