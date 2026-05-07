{ config, pkgs, ... }:

let
  sops-nix = builtins.fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
in

{
  imports = [
    "${sops-nix}/modules/sops"
  ];

  # OpenSSH — kept disabled for external access; host key at /etc/ssh/ssh_host_ed25519_key is used by sops-nix
  services.openssh = {
    enable = true;
    openFirewall = false;
  };

  # sops secrets — uncomment after running bootstrap sequence in README
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/etc/age/keys.txt"; # personal break-glass key — restore from Bitwarden
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
}
