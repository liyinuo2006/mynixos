{
  description = "Orion's NixOS flake";

  nixConfig = {
    substituters = [
      # 3个国内大学镜像(tuna 只镜像活跃 channel 的部分路径,
      # 其他 nixpkgs rev 的依赖要 SJTU/USTC 才有,所以全开)
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
      #"https://mirror.sjtu.edu.cn/nix-channels/store?priority=20"
      #"https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
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
      # hermes-agent（Tier 2，缓存未必每 rev 都有）
      "https://hermes-agent.cachix.org"
      # llm-agents.nix（numtide 每日更新的 AI agent 包集合）
      "https://cache.numtide.com?priority=50"
      # deepseek-harness（dsh）Nix 打包缓存
      "https://deepseek-harness-nix.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA="
      "tg-owt.cachix.org-1:lp0BukIhSK3EIyLcDhDZ5zABgT48nmNp6t4SnZ0wr8w="
      "fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="
      # hermes-agent（Tier 2，缓存未必每 rev 都有；密钥经 GitHub 实配案例核实）
      "hermes-agent.cachix.org-1:jN3pjR50Mxi4SESKC/FIMNM6/LCosvPk2VUwzVvebzU="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      # deepseek-harness（dsh）Nix 打包缓存
      "deepseek-harness-nix.cachix.org-1:5NrkwLN9veNMhiINtU5ZeV4isXFhFsOwn6Ms7J1M+TA="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 密钥管理：sops 加密文件 + age 密钥，激活时解密到 /run/secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Greeter(greetd 登录界面,与 Noctalia v5 配对使用)
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # 锁到 9d70169：上游 nix-cache #22 已推送该 rev 的完整依赖链缓存（issue #117）。
    # 升级：上游发新 v* tag（有缓存）时，改回 github:xifan2333/fcitx5-vinput
    # 后跑 nix flake lock --update-input fcitx5-vinput，或直接 pin 到新 tag。
    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput/9d70169";
    };

    # 闪狐云 Lite 机场客户端(闭源 deb vendor 在仓库内,系统代理模式)
    flashfox-lite = {
      url = "github:liyinuo2006/flashfox-lite-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hermes Agent(ai agent,仅从它取包安装到 HM;NixOS 服务已废弃)
    # 保持独立 nixpkgs pin(与 noctalia/fcitx5-vinput 同惯例):Tier 2 flake,
    # 上游 main 可能破坏构建,用 flake.lock 锁定,升级时先查上游提交
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
    };

    # llm-agents.nix：AI agent 包集合（numtide 维护，每日自动更新）
    # 保持独立 nixpkgs pin：llm-agents 内部 pin 自己的 nixpkgs-unstable，
    # 缓存与 CI 测试组合一一对应；升级用 nix flake lock --update-input llm-agents
    llm-agents.url = "github:numtide/llm-agents.nix";

    # deepseek-harness（dsh）的 Nix 打包：bundle/preset/profile 插件体系 + HM 模块
    # 保持独立 nixpkgs pin（与 hermes/noctalia 同惯例）：Tier 2 flake，
    # 上游 dsh 处于 developer preview 快速迭代期，用 flake.lock 锁定，
    # 升级前先查上游提交再 nix flake lock --update-input deepseek-harness
    deepseek-harness.url = "github:Moraxyc/deepseek-harness.nix";

    # NUR(社区包仓库)：waydroid-script 转译层安装脚本来自
    # repos.ataraxiasjel.waydroid-script（NixOS wiki 推荐用法）
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
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
