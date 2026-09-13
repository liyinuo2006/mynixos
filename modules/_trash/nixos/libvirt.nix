# ============================================================================
# 废弃：libvirt / virt-manager（KVM 虚拟机，2026-09 停用，用户不再使用）
#
# 本文件是「删除前」的原始配置快照，放在垃圾桶里等系统切换确认无误后再删。
# 本目录不被任何 default.nix 导入，不要从 _trash 里 import 任何东西。
#
# 删除时的完整改动（除本文件外）：
#   - 删除空聚合器 modules/nixos/virtualisation/default.nix，
#     整个 modules/nixos/virtualisation/ 目录随之为空被移除
#   - hosts/vostro-3420/default.nix 的 imports 里移除
#     ../../modules/nixos/virtualisation
#   - modules/nixos/core/users.nix 的 extraGroups 里移除 "libvirtd"
#   - README.md「未被声明的部分」里移除 libvirt 说明
#   - hardware-configuration.nix 的 kvm-intel 内核模块保留未动
#
# ---- 如果要恢复到未删除的状态，按以下步骤操作 ----
#
# 1) 重建聚合器模块 modules/nixos/virtualisation/default.nix，内容为：
#      { ... }:
#      {
#        imports = [
#          ./libvirt.nix
#        ];
#      }
#
# 2) 把本文件移回原位：
#      git mv modules/_trash/nixos/libvirt.nix \
#             modules/nixos/virtualisation/libvirt.nix
#
# 3) 在 hosts/vostro-3420/default.nix 的 imports 里加回：
#      ../../modules/nixos/virtualisation
#
# 4) 在 modules/nixos/core/users.nix 的 extraGroups 里加回：
#      "libvirtd"
#
# 5) 在 README.md「未被声明的部分」里加回 libvirt 说明：
#      - libvirt: 执行以下命令 nat 网络 ||
#        sudo virsh net-start default  ||
#        sudo virsh net-autostart default # 默认网络默认是停用的
#
# 6) 切换系统：
#      sudo nixos-rebuild switch --flake .#mynixos
#
# 7) 运行数据（虚拟机 archlinux、磁盘 /var/lib/libvirt 等）已在删除时清空，
#    若需重新使用需重新初始化：
#      sudo virsh net-define ...   # 或让虚拟化模块重建默认网络
#      sudo virsh net-start default && sudo virsh net-autostart default
#      再用 virt-manager 新建虚拟机
#
# 注意：libvirt 的 virbr0 NAT 会把 net.ipv4.ip_forward 设为 1；删除后该值不再
# 被设置，重启后回到 0。闪狐 TUN 若需要它，请自行确认补上。
# ============================================================================
{
  pkgs,
  ...
}:
{
  # libvirt + virt-manager：图形化管理 KVM 虚拟机（社区主流方案，VM 本身用 GUI 命令式创建）
  # 官方文档：https://wiki.nixos.org/wiki/Virt-manager  https://wiki.nixos.org/wiki/Libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      # 共享文件夹需要 virtiofsd（wiki 推荐加进 vhostUserPackages）
      vhostUserPackages = [ pkgs.virtiofsd ];
      # TPM 仿真（libvirt wiki 建议；Windows 11 等需要 TPM 的来宾才用得上）
      swtpm.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  # SPICE USB 重定向（把主机 USB 设备透传给来宾）
  virtualisation.spiceUSBRedirection.enable = true;

  # 默认网络 virbr0 的 DNS/DHCP 由 dnsmasq 提供（wiki 明确要求，否则默认网络不可用）
  environment.systemPackages = [ pkgs.dnsmasq ];
}
