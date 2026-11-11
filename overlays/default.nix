{ inputs }:
[
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
      overlays = [
        (_: usuper: {
          mistral-vibe = usuper.mistral-vibe.overridePythonAttrs (old: {
            doCheck = false;
            passthru = old.passthru // {
              vibe-rs = old.passthru.vibe-rs.overrideAttrs (vibeOld: {
                buildInputs = vibeOld.buildInputs ++ [ usuper.aws-lc ];
              });
            };
          });
        })
      ];
    };

    cosmic-ext-alternative-startup = final.callPackage ../pkgs/cosmic-ext-alternative-startup.nix { };
  })

  (final: prev: {
    dotnetCorePackages = prev.dotnetCorePackages.overrideScope (
      _sfinal: sprev:
      prev.lib.mapAttrs (
        _name: val:
          if (prev.lib.hasInfix "-wrapped-" (val.name or "")) && val ? outPath then
            val.overrideAttrs (old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
              postFixup = (old.postFixup or "") + ''
                rm -f "$out/bin/dotnet"
                makeWrapper "$src/share/dotnet/dotnet" "$out/bin/dotnet" --unset LD_LIBRARY_PATH
              '';
            })
          else
            val
      ) sprev
    );
  })
]
