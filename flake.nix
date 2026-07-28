{
  description = "Orion's NixOS flake 3";

  nixConfig = {
    substituters = [
      # 3个国内大学镜像
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
      #"https://mirror.sjtu.edu.cn/nix-channels/store?priority=20"
      #"https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
      # 官方原站
      "https://cache.nixos.org?priority=40"
      # 社区缓存
      "https://nix-community.cachix.org?priority=45"
      # noctalia v5
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen 浏览器(社区 flake)
    # 使用 beta 分支:仅在 beta 渠道更新时移动,不受 main 分支每日 twilight 更新干扰
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.mynixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vostro-3420
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
