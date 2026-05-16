{
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    seahorse
    libsecret
  ];

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/etc/age/keys.txt"; # restore from Bitwarden
}
