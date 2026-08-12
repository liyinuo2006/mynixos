{ ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 13.0;
    };
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      cursor_shape = "beam";
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      copy_on_select = "clipboard";
      background_opacity = 0.8;
      hide_window_decorations = true;
    };
    extraConfig = "include themes/noctalia.conf";
  };
}
