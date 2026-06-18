# PS1 from https://github.com/lissy93/minimal-terminal-prompt

{
  pkgs,
  config,
  lib,
  ...
}:
let
  blerc = pkgs.writeText "blerc" ''
    bleopt history_share=1

    _ble_contrib_fzf_base=${pkgs.fzf}/share/fzf
    ble-import -d integration/fzf-completion
    ble-import -d integration/fzf-key-bindings
  '';
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyFile = "${config.xdg.dataHome}/bash/history";
    historySize = 100000;
    historyFileSize = 100000;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    bashrcExtra = ''
      [[ $- == *i* ]] && source "${pkgs.blesh}/share/blesh/ble.sh" --noattach --rcfile "${blerc}"
    '';

    initExtra = lib.mkMerge [
      ''
        export MAMBA_ROOT_PREFIX="$HOME/.micromamba"
        micromamba() {
          unset -f micromamba conda
          eval "$(command micromamba shell hook --shell bash)"
          conda() { micromamba "$@"; }
          micromamba "$@"
        }
        conda() { micromamba "$@"; }

        ## Echo the current git branch, if inside a repo
        parse_git_branch() {
          git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
        }

        ## Bright yellow when the tree has changes, bright green when clean
        parse_git_changes() {
          if [[ $(git status --porcelain) ]]; then
            echo '\[\e[93m\]'
          else
            echo '\[\e[92m\]'
          fi
        }

        ## Rebuild PS1 on every prompt
        set_bash_prompt() {
          PS1='\[\e[0m\]'
          PS1+='\[\e[1m\]\[\e[35m\]\u @ \h \[\e[0m\]\[\e[37m\]\w '

          if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
            PS1+="$(parse_git_changes)"
            PS1+="$(parse_git_branch)"
          fi

          PS1+='\n\[\e[35m\]└─▶ '
          PS1+='\[\e[0m\]'
        }

        PROMPT_COMMAND=set_bash_prompt
      ''

      (lib.mkOrder 5000 ''
        [[ ''${BLE_VERSION-} ]] && ble-attach
      '')
    ];
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--oneline"
      "--all"
      "--group-directories-first"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
  };
}
