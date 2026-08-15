{ ... }:

{
  systemd.user.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    NIXOS_OZONE_WL = "1";
    # 全局编辑器：Zed（--wait 等待窗口关闭；命令名是 zeditor）
    EDITOR = "zeditor --wait";
  };
}
