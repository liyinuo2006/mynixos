# AWS EC2 根卷布局：UEFI + GPT，根卷是 NVMe 设备 /dev/nvme0n1（Nitro 实例）。
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        # ESP 直接挂 /boot：GRUB 的 kernel/initrd 与 grub.cfg 都放这里
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
