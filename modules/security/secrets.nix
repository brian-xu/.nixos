{
  config,
  ...
}:

{
  # sops secrets
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
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

  sops.secrets.discord_ip.sopsFile = ../../secrets/ssh-ips.yaml;
  sops.secrets.racknerd_ip.sopsFile = ../../secrets/ssh-ips.yaml;
  sops.secrets.debian_ip.sopsFile = ../../secrets/ssh-ips.yaml;

  sops.templates."ssh-hosts.conf" = {
    owner = "brian";
    content = ''
      Host discord.us-central1-a.cloud-computation-136
        HostName ${config.sops.placeholder.discord_ip}

      Host racknerd
        HostName ${config.sops.placeholder.racknerd_ip}

      Host debian
        HostName ${config.sops.placeholder.debian_ip}
    '';
  };
}
