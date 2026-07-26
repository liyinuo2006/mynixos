{ ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      fg = 7;
      bg = 0;
      # clock = "%c";
      hide_borders = true;
      bigclock = true;
      animate = true;
      animation = "matrix";
    };
  };
}
