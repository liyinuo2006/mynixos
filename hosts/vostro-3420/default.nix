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
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; }; # 在 hm 中使用 flake 的 inputs 参数
    users.orion = import ../../home/orion;
  };

  system.stateVersion = "26.05";
}
