# ============================================================================
# 废弃：Waydroid（2026-09 停用，用户不再使用 Android 容器）
#
# 本文件是「删除前」的原始配置快照，放在垃圾桶里等系统切换确认无误后再删。
# 本目录不被任何 default.nix 导入，不要从 _trash 里 import 任何东西。
#
# ---- 如果要恢复到未删除的状态，按以下步骤操作 ----
#
# 1) 把本文件移回原位：
#      git mv modules/_trash/nixos/waydroid.nix \
#             modules/nixos/virtualisation/waydroid.nix
#
# 2) 在 modules/nixos/virtualisation/default.nix 的 imports 里加回：
#      ./waydroid.nix
#
# 3) 在 flake.nix 的 inputs 里加回 NUR（waydroid.nix 需要
#    pkgs.nur.repos.ataraxiasjel.waydroid-script，别处不再使用 NUR）：
#      nur = {
#        url = "github:nix-community/NUR";
#        inputs.nixpkgs.follows = "nixpkgs";
#      };
#
# 4) 在 README.md「未被声明的部分」里加回 Waydroid 说明：
#      - waydroid:
#        初始化与启动
#        sudo waydroid init -s GAPPS   # 初始化镜像；-s GAPPS 带谷歌服务，-f 强制重装
#        sudo waydroid-script               # 选 Android 13 → Install → libhoudini
#        sudo systemctl start waydroid-container # 以后开机自启，不用手动
#        waydroid session start        # 看到 "Android with user 0 is ready" 即成功
#        日常使用
#        waydroid show-full-ui                                    # 全屏模式
#        waydroid prop set persist.waydroid.multi_windows true    # 多窗口模式（需重启 session）
#
# 5) 更新锁文件（NUR 已从 flake.lock 移除，需要重新拉取）：
#      nix flake lock
#
# 6) 切换系统：
#      sudo nixos-rebuild switch --flake .#mynixos
#
# 7) 运行数据已在删除时清空，若需重新使用需重新初始化镜像：
#      sudo waydroid init -s GAPPS
#      sudo waydroid-script        # 选 Android 13 → Install → libhoudini
#      sudo systemctl start waydroid-container
#
# 注意：本文件里含 boot.kernel.sysctl."net.ipv4.ip_forward" = true（Waydroid 的
# NAT 需要）。当初删除时已一并移除，libvirt 的 virbr0 NAT 是否需要它请自行确认。
# ============================================================================
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
    # 共享文件夹：把宿主目录 bind 挂载进容器（wiki: Mount host directories）
    # 配套服务：systemctl --user start waydroid-monitor，再开 GUI 添加共享目录
    pkgs.waydroid-helper
  ];

  # waydroid-helper 的系统挂载服务（用户服务 waydroid-monitor 需登录后手动启动）
  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  };
}
