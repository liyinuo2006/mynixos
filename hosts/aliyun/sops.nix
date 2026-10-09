# aliyun 的系统级 sops：只解密 EasyTier 网络口令。
#
# 云主机是独立 host，不复用桌面的 modules/nixos/security（那里含 orion 密码 hash、
# github-token 等只应留在本机的秘密），因此单独导入 sops-nix 并只声明这一条。
#
# age 私钥不从文件读取，而是由 SSH host key 派生（sops-nix 内部调用 ssh-to-age）：
# 需先把 /etc/ssh/ssh_host_ed25519_key.pub 转换出的 age 公钥列为
# modules/nixos/security/.sops.yaml 里 secrets/easytier.yaml 的收件人。
#
# 取公钥（在 aliyun 上）：
#   nix shell nixpkgs#ssh-to-age -c ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = [ pkgs.sops ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../modules/nixos/security/secrets/easytier.yaml;

    secrets."easytier-network-secret" = { };

    templates."easytier-env" = {
      content = "ET_NETWORK_SECRET=${config.sops.placeholder."easytier-network-secret"}";
      mode = "0400";
    };
  };
}
