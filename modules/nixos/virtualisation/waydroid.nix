{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    # NUR overlay：提供 pkgs.nur.repos.ataraxiasjel.waydroid-script（ARM 转译层安装脚本）
    inputs.nur.modules.nixos.default
  ];

  # Waydroid：在 Linux 上以 LXC 容器运行完整 Android 系统（基于 LineageOS）
  # 官方文档：https://docs.waydro.id/  NixOS wiki：https://wiki.nixos.org/wiki/Waydroid
  virtualisation.waydroid = {
    enable = true;
    # nixos-unstable 较新内核需要 nftables 后端
    package = pkgs.waydroid-nftables;
  };

  # Waydroid 容器经 waydroid0 + NAT masquerade 上网，依赖 ip_forward（NixOS 默认关闭）
  # 防火墙已由 waydroid 模块自动把 waydroid0 加入 trustedInterfaces
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;

  environment.systemPackages = [
    # 剪贴板共享（waydroid 依赖 wl-clipboard）
    pkgs.wl-clipboard
    # ARM 转译层：运行只发布 ARM 版的安卓应用（Intel CPU 用 libhoudini，AMD 用 libndk）
    # 用法：sudo waydroid-script → 选 Android 13 → Install → libhoudini
    pkgs.nur.repos.ataraxiasjel.waydroid-script
  ];
}
