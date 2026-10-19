{
  osConfig,
  ...
}:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [ osConfig.sops.templates."ssh-hosts.conf".path ];

    settings = {
      "discord.us-central1-a.cloud-computation-136" = {
        User = "brianxu";
        IdentityFile = "~/.ssh/google_compute_engine";
        IdentitiesOnly = "yes";
        CheckHostIP = "no";
      };
      racknerd = {
        User = "root";
        Port = "48484";
        IdentityFile = "~/.ssh/racknerd";
      };
      debian = {
        User = "bob";
      };
      "github.com" = {
        HostName = "ssh.github.com";
        Port = "443";
        User = "git";
        HostKeyAlias = "github.com";
      };
    };
  };
}
