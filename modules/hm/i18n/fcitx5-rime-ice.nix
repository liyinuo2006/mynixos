{
  pkgs,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = with pkgs; [ rime-ice ];
        })
        fcitx5-gtk # GTK 应用支持
      ];
    };
  };
}
