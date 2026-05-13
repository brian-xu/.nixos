{ config, pkgs, ... }:
{
  # sops-nix module is loaded at flake level; this configures the age key sources.
  # Host-specific secrets (defaultSopsFile, sops.secrets.*) live in the system config.

  # OpenSSH — kept disabled for external access; host key is used by sops-nix for age decryption
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/etc/age/keys.txt"; # personal break-glass key — restore from Bitwarden
}
