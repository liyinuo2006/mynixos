{
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.xrdb # 给 XWayland 灌 Xft.dpi(微信/WPS 里 fcitx5 候选框缩放)
  ];
}
