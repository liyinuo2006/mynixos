# 阿里云 ECS 云主机磁盘布局：UEFI + GPT。
# 设备名以实测为准：本机为 virtio-blk 的 /dev/vda
# （阿里云控制台里显示 /dev/xvda 是旧写法，实际内核里是 /dev/vda）。
{
  disko.devices.disk.vda = {
    type = "disk";
    device = "/dev/vda";
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
