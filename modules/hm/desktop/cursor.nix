{ pkgs, ... }:

{
  # 光标主题:装主题包 + 设 XCURSOR_* 环境变量 + 链接到 ~/.icons/
  # niri 那边(desktop/niri-config/miscellaneous.kdl)再指定同一主题画 Wayland 光标
  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    # 逻辑像素大小,内屏 scale 1.5,24 正好
    size = 24;
    gtk.enable = true;
  };
}
