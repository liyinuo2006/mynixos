{
  config,
  ...
}:
{
  users.users.orion = {
    isNormalUser = true;
    description = "Orion";

    # 密码 hash 由 sops 在用户创建前解密(neededForUsers)，见 modules/nixos/security/sops.nix
    hashedPasswordFile = config.sops.secrets."orion-password-hash".path;

    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
    ];
  };
}
