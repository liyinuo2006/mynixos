{ ... }:
{
  # 系统服务：音频/电源/可移动介质/快照（按 services.* 命名空间归类）
  imports = [
    ./pipewire.nix
    ./power.nix
    ./removable-media.nix
    ./btrfs-snapshots.nix
  ];
}
