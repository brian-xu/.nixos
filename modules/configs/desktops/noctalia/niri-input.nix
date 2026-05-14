{
  ...
}:

{
  programs.niri.settings.input = {
    keyboard.xkb.layout = "us";
    touchpad = {
      click-method = "button-areas";
      dwt = true;
      dwtp = true;
      natural-scroll = true;
      scroll-method = "two-finger";
      tap = true;
      tap-button-map = "left-right-middle";
      middle-emulation = true;
      accel-profile = "adaptive";
    };
    focus-follows-mouse.enable = true;
    warp-mouse-to-focus.enable = false;
  };
}
