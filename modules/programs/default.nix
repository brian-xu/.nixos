{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    micromamba
    nixd
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
      eval "$(micromamba shell hook -s zsh)"
    '';
  };

  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
