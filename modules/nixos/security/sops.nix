{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = [ pkgs.sops ];

  sops = {
    # age 私钥：本机唯一的机密文件，丢失则密文永久不可解密
    # 注意：必须放在根文件系统(@子卷)上，不能放 /home(orion 的用户目录)——
    # sops 在 initrd 早期激活阶段解密，此时 @home 子卷尚未挂载
    age.keyFile = "/var/lib/sops-nix/key.txt";
    # 加密的 secrets 文件（与 .sops.yaml 同目录维护，密文可入库）
    defaultSopsFile = ./secrets/api-key.yaml;
    secrets."hermes-env" = {
      format = "yaml";
      # 该文件由 hermes-agent 服务读取（environmentFiles）
      mode = "0600";
    };
  };
}
