[
  (final: prev: {
    kdePackages = prev.kdePackages.overrideScope (
      kfinal: kprev: {
        dolphin = (import ./dolphin.nix) prev kprev;
      }
    );
  })
]
