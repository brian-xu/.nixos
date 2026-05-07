{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    micromamba
  ];
  environment.shellAliases = {
    conda = "micromamba";
  };
  environment.sessionVariables = {
    # Use conda-forge channel by default
    MAMBARC = "${./mambarc.yml}";
    # Personal preference, default is ~/.micromamba
    MAMBA_ROOT_PREFIX = "~/.local/share/mamba";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    ohMyZsh.theme = "frisk";
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      mkdir -p $MAMBA_ROOT_PREFIX
      eval "$(micromamba shell hook -s zsh)"
    '';
  };
  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
