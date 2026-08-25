# cua-driver：Computer Use 后台桌面驱动（trycua/cua）。
#
# 采用官方 NixOS 模块（inputs.cua.nixosModules.cua-driver）——它会自动带上
# cua-driver 真正需要的运行时依赖：
#   - imagemagick   （capture.rs 窗口截图用的 `import` 命令）
#   - at-spi2-core  （AT-SPI 无障碍总线守护进程；元素识别/无障碍树的关键）
#   - services.dbus.enable = true
#   - environment.variables.CUA_DRIVER_BIN
#
# 注意：只用 Nix 构建版（inputs.cua.packages.<system>.cua-driver），不要用官方
# curl|bash 预编译二进制——那个把 portal-libei（Wayland 输入）feature-gate 关掉了，
# 在 niri（纯 Wayland）上只能看到代理光标、点击无法派发（trycua/cua issue #1982）。
# Nix 包用 --features portal-input,portal-capture（== portal-libei）已编入 libei + pipewire。
#
# 为何不 follow 根 nixpkgs：cua 上游将包构建 pin 在它自带的 nixos-26.05（libei/pipewire
# 组合经过验证），跟 nixos-unstable 走有 libspa/libei API 漂移风险。升级走
# `nix flake lock --update-input cua`。
{ inputs, pkgs, ... }:
{
  imports = [ inputs.cua.nixosModules.cua-driver ];

  services.cua-driver = {
    enable = true;
    package = inputs.cua.packages.${pkgs.stdenv.hostPlatform.system}.cua-driver;
  };
}
