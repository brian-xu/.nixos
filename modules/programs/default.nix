{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    micromamba
    nixd
    fastfetch
  ];
  environment.shellAliases.conda = "micromamba";

  programs.git.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    ohMyZsh.theme = "frisk";
    syntaxHighlighting.enable = true;
    shellInit = ''
      export MAMBA_ROOT_PREFIX="$HOME/.micromamba"
    '';
    interactiveShellInit = ''
      mkdir -p "$MAMBA_ROOT_PREFIX"
      eval "$(micromamba shell hook -s zsh | sed 's/^__exe_name=.*$/__exe_name="micromamba"/')"
    '';
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
  };

  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
