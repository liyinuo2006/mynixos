{ config, ... }:
{
  # sops 编辑密钥与系统解密密钥统一：家目录只留符号链接指向
  # /var/lib/sops-nix/key.txt，不存第二份私钥副本。
  # 旧的家目录实体副本会被 HM 改名为 keys.txt.hm-backup。
  home.file.".config/sops/age/keys.txt".source =
    config.lib.file.mkOutOfStoreSymlink "/var/lib/sops-nix/key.txt";
}
