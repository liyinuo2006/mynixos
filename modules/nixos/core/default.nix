{ ... }:
{
  # 核心模块只包含所有机器都需要的基础系统能力。
  imports = [
    ./boot.nix
    ./nix.nix
    ./locale.nix
    ./networking.nix
    ./users.nix
    ./hardware.nix
  ];
}
