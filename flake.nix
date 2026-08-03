{
  description = "Orion's NixOS flake 3";

  nixConfig = {
    substituters = [
      # 3个国内大学镜像(tuna 只镜像活跃 channel 的部分路径,
      # 其他 nixpkgs rev 的依赖要 SJTU/USTC 才有,所以全开)
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
      "https://mirror.sjtu.edu.cn/nix-channels/store?priority=20"
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
      # 官方原站
      "https://cache.nixos.org?priority=40"
      # 社区缓存
      "https://nix-community.cachix.org?priority=45"
      # noctalia v5
      "https://noctalia.cachix.org"
      # ayugram-desktop
      "https://ayugram-desktop.cachix.org"
      # AyuGram 的 tg_owt 依赖
      "https://tg-owt.cachix.org"
      # fcitx5-vinput 语音输入
      "https://fcitx5-vinput.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA="
      "tg-owt.cachix.org-1:lp0BukIhSK3EIyLcDhDZ5zABgT48nmNp6t4SnZ0wr8w="
      "fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="
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

    # Spicetify(声明式包装 Spotify)
    # 文档:https://wiki.nixos.org/wiki/Spicetify-Nix
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AyuGram(Telegram 增强客户端,NixOS flake 打包)
    # README 要求 git 类型 + submodules,否则构建失败
    ayugram-desktop = {
      type = "git";
      submodules = true;
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };

    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
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
