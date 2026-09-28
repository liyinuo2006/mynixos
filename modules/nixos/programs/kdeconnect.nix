# KDE Connect：手机与电脑互通，供 Noctalia 的 icefish/phone-operate 插件使用。
#
# 只需系统级开启：nixpkgs 的 programs.kdeconnect 模块会
#   1) 把 kdePackages.kdeconnect-kde 装进 systemPackages；
#   2) 放行 1714–1764 的 TCP/UDP 端口（kdeconnectd 的设备发现与传输必需）。
# 防火墙只有系统层能动，所以这一条必须在 NixOS 侧，不能放 Home Manager。
#
# 用户侧命令（scrcpy / android-tools / sshfs / gdbus）见
# modules/hm/programs/phone-control.nix。
{ ... }:

{
  programs.kdeconnect.enable = true;
}
