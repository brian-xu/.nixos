{
  lib,
  pkgs,
  ...
}:

let
  zed = pkgs.unstable.zed-editor-fhs;
in
{
  programs.zed-editor = {
    enable = true;
    package = zed;

    extensions = [
      "csharp"
      "gdscript"
      "latex"
      "nix"
      "toml"
      "dockerfile"
      "git-firefly"
      "markdown-oxide"
      "terraform"
      "html"
    ];

    userSettings = {

      cli_default_open_behavior = "new_window";
      autosave = "on_focus_change";

      agent_servers = {
        "mistral-vibe" = {
          favorite_config_option_values = {
            mode = [ "auto-approve" ];
          };
          default_config_options = {
            mode = "auto-approve";
          };
          type = "registry";
        };
      };

      debugger = {
        dock = "left";
      };

      terminal = {
        dock = "bottom";
        flexible = true;
      };

      outline_panel = {
        dock = "left";
      };

      git_panel = {
        dock = "left";
      };

      project_panel = {
        dock = "left";
      };

      agent = {
        threads_sidebar = {
          auto_open = false;
          position = "right";
        };
        dock = "right";
      };

      collaboration_panel = {
        dock = "right";
      };

      base_keymap = "VSCode";

      preview_tabs = {
        enabled = false;
      };

      buffer_font_family = "MonaspiceNe Nerd Font";
      theme = "One Dark";

      # --- nix integration ---
      auto_update = false;

      # Use node/npm from nixpkgs
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      lsp = {
        nil = {
          binary = {
            path = lib.getExe pkgs.nil;
          };
        };

        "terraform-ls" = {
          binary = {
            path = lib.getExe pkgs.terraform-ls;
          };
        };

        roslyn = {
          binary = {
            env = {
              DOTNET_ROOT = "${pkgs.dotnetCorePackages.runtime_10_0}/share/dotnet";
            };
          };
        };
      };
    };
  };

  # expose Zed's CLI as `zed` instead of `zeditor`
  home.packages = [
    pkgs.nil
    pkgs.terraform-ls
    pkgs.dotnetCorePackages.runtime_10_0
    (pkgs.runCommand "zed-cli" { } ''
      mkdir -p $out/bin
      ln -s ${lib.getExe zed} $out/bin/zed
    '')
  ];
}
