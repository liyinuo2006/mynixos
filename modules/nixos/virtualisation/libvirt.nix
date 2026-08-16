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
