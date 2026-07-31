{
  config,
  ...
}:
{
  xdg.configFile = {
    "niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/mynixos/modules/hm/desktop/niri-config/config.kdl";
    "niri/binds.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/mynixos/modules/hm/desktop/niri-config/binds.kdl";
    "niri/environment.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/mynixos/modules/hm/desktop/niri-config/environment.kdl";
    "niri/window-rule.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/mynixos/modules/hm/desktop/niri-config/window-rule.kdl";
    "niri/layer-rule.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/mynixos/modules/hm/desktop/niri-config/layer-rule.kdl";

  };

  wayland.windowManager.niri = {
    enable = true;
  };

}
