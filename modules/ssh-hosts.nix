{
  user = "brian";

  hostsTemplate = "ssh-hosts.conf";

  identities = {
    ssh_id_ed25519 = "id_ed25519";
    racknerd = "racknerd";
    google_compute_engine = "google_compute_engine";
  };

  hosts = {
    discord = {
      alias = "discord.us-central1-a.cloud-computation-136";
      user = "brianxu";
      identity = "google_compute_engine";
      identitiesOnly = "yes";
      checkHostIP = "no";
      ipSecret = "discord_ip";
    };
    racknerd = {
      alias = "racknerd";
      user = "root";
      port = "48484";
      identity = "racknerd";
      ipSecret = "racknerd_ip";
    };
    debian = {
      alias = "debian";
      user = "bob";
      ipSecret = "debian_ip";
    };
    github = {
      alias = "github.com";
      hostName = "ssh.github.com";
      port = "443";
      user = "git";
      hostKeyAlias = "github.com";
    };
  };
}
