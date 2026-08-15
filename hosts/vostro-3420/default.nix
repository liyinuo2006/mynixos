{
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core
    ../../modules/nixos/programs
    ../../modules/nixos/dm
    ../../modules/nixos/wm
    ../../modules/nixos/security
    ../../modules/nixos/ai-agent
    ../../modules/nixos/virtualisation
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; }; # 在 hm 中使用 flake 的 inputs 参数
    # 注册 sops-nix 的 Home Manager 模块（noctalia 密钥等用户级解密用）
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
    users.orion = import ../../home/orion;
  };

  system.stateVersion = "26.05";
}
