# AWS EC2（Nitro：NVMe + ENA 网卡）硬件配置占位。
# 安装时由 nixos-anywhere 的 --generate-hardware-config 覆盖为真机结果；
# 文件系统由 disko（./disk-config.nix）管理，swap 见 ./default.nix。
{
  lib,
  ...
}:

{
  boot.initrd.availableKernelModules = [
    "nvme"
    "ena"
    "virtio_pci"
    "virtio_blk"
    "sd_mod"
    "uas"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
