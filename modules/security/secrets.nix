{
  config,
  lib,
  ...
}:

let
  # Secrets are only activated when the age key is present (restored from
  # Bitwarden per README). This lets a fresh install boot and rebuild without
  # the key; SSH keys simply appear after the key is staged and the system is
  # rebuilt.
  haveAgeKey = builtins.pathExists config.sops.age.keyFile;
in
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.secrets = lib.mkIf haveAgeKey {
    ssh_id_ed25519 = {
      path = "/home/brian/.ssh/id_ed25519";
      owner = "brian";
      mode = "600";
    };
    racknerd = {
      path = "/home/brian/.ssh/racknerd";
      owner = "brian";
      mode = "600";
    };
    google_compute_engine = {
      path = "/home/brian/.ssh/google_compute_engine";
      owner = "brian";
      mode = "600";
    };

    discord_ip.sopsFile = ../../secrets/ssh-ips.yaml;
    racknerd_ip.sopsFile = ../../secrets/ssh-ips.yaml;
    debian_ip.sopsFile = ../../secrets/ssh-ips.yaml;
  };

  sops.templates = lib.mkIf haveAgeKey {
    "ssh-hosts.conf" = {
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
  };
}
