prev: kprev:
prev.symlinkJoin {
  name = "dolphin-wrapped";
  paths = [ kprev.dolphin ];
  nativeBuildInputs = [ prev.makeWrapper ];
  postBuild = ''
    rm $out/bin/dolphin
    makeWrapper ${kprev.dolphin}/bin/dolphin $out/bin/dolphin \
      --set XDG_CONFIG_DIRS "${prev.libsForQt5.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
      --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${prev.libsForQt5.kservice}/etc/xdg/menus/applications.menu"
  '';
}
