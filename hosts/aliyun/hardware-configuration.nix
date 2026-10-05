# 阿里云 ECS（KVM + virtio）硬件配置。
# 文件系统由 disko（./disk-config.nix）管理，swap 见 ./default.nix（swapfile）。
# 需要重新探测时可让 nixos-anywhere 覆盖：
#   --generate-hardware-config nixos-generate-config ./hosts/aliyun/hardware-configuration.nix
{
  lib,
  ...
}:

{
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "virtio_net"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
