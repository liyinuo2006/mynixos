{
  inputs,
  ...
}:
{

  nix = {

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        # 3个国内大学镜像
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
        #"https://mirror.sjtu.edu.cn/nix-channels/store?priority=20"
        #"https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
        # 官方原站
        "https://cache.nixos.org?priority=40"
        # 社区缓存
        "https://nix-community.cachix.org?priority=45"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "@wheel"
        "root"
      ];
      auto-optimise-store = false;
    };

    gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 7d";
    };

    # 定期合并内容相同的 store 文件，节省磁盘空间。
    optimise = {
      automatic = true;
      dates = [ "3:45" ];
    };
  };
}
