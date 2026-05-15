{
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/etc/age/keys.txt"; # restore from Bitwarden
}
