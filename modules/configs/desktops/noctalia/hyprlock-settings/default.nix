{
  programs.hyprlock.settings = {
    general = {
      hide_cursor = false;
      ignore_empty_input = true;
    };

    auth = {
      fingerprint = {
        enabled = true;
      };
    };

    background = [
      {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }
    ];

    input-field = [
      {
        size = "200, 50";
        position = "0, -80";
        dots_center = true;
        fade_on_empty = false;
        outline_thickness = 5;
        shadow_passes = 2;
      }
    ];
  };
}
