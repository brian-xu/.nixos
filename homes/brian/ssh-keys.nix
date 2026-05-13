{ ... }:
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
  sops.secrets.brian-1 = {
    path = "/home/brian/.ssh/brian-1.pem";
    owner = "brian";
    mode = "600";
  };
}
