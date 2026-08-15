{ ... }:
{
  # 核心模块只包含所有机器都需要的基础系统能力。
  imports = [
    ./boot.nix
    ./nix.nix
    # ./nix-ld.nix
    ./locale.nix
    ./networking.nix
    ./users.nix
    ./power.nix
    ./hardware.nix
    ./pipewire.nix
    ./removable-media.nix
    ./btrfs-snapshots.nix
  ];
}
