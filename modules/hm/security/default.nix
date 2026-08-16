{ ... }:
{
  # 用户级密钥/授权（与 modules/nixos/security 对应）
  imports = [
    ./sops.nix
  ];
}
