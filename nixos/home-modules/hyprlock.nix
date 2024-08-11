{
  ...
}: {
  programs.hyprlock = {
    enable = true;
    
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          color = "rgba(250, 244, 237, 1.0)";
          blur_passes = 0;
        }
      ];

      input-field = [
        {
          size = 500, 60;
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.35;
          dots_center = true;
          outer_color = "rgba(215, 130, 126, 1.0)";
          inner_color = "rgba(255, 250, 243, 1.0)";
          font_color = "rgb(87, 82, 121)";
          fade_on_empty = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          placeholder_text = "Hi, are you looking for the other side?";
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Date
        {
          text = "cmd[update:1000] echo \"$(date +'%A, %B %d')\"";
          color = "rgb(87, 82, 121)";
          font_size = 22;
          font_family = "0xProto";
          position = "0, 300";
          halign = "center";
          valign = "center";
        },
        {
          text = "cmd[update:1000] echo \"$(date +'%-I:%M')\"";
          color = "rgb(87, 82, 121)";
          font_size = 95;
          font_family = "0xProto";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}