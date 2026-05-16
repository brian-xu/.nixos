{
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  security.pam.services = with pkgs; {
    login.kwallet = {
      enable = true;
      package = kdePackages.kwallet-pam;
    };
    kde.kwallet = {
      enable = true;
      package = kdePackages.kwallet-pam;
    };
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/etc/age/keys.txt"; # restore from Bitwarden
}
