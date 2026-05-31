[
  (final: prev: {
    nautilus = prev.nautilus.overrideAttrs (nprev: {
      buildInputs =
        nprev.buildInputs
        ++ (with prev.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
          gst-libav
        ]);
    });
    kdePackages = prev.kdePackages.overrideScope (
      kfinal: kprev: {
        dolphin = (import ./dolphin.nix) prev kprev;
      }
    );
  })
]
