# 手机控制：为 Noctalia 的 icefish/phone-operate 插件（v1.0.1）提供前置命令。
# 插件本身在 Noctalia 的插件页安装，不由 Nix 管理；这里只装插件在运行时调用的外部工具：
#   scrcpy        投屏与操控手机屏幕
#   android-tools adb：设备发现、无线调试配对/连接
#   sshfs         浏览手机文件（SFTP 挂载）
#   glib          gdbus：插件经 DBus 调 KDE Connect 用（KDE Connect 的 CLI 不保证带上它）
#
# 注意：KDE Connect 本体（kdeconnectd / kdeconnect-cli）不在这里装。它需要在 NixOS 层开启
# `programs.kdeconnect.enable = true`（安装 kdeconnect-kde 并放行 1714–1764 的 TCP/UDP
# 端口），Home Manager 管不到防火墙，单独在用户层装包会连不上手机。
# 对应模块：modules/nixos/programs/kdeconnect.nix。
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    scrcpy
    android-tools
    sshfs
    glib
  ];
}
