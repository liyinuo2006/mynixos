{
  description = "Orion's NixOS flake";

  # 缓存与信任密钥统一从 modules/nixos/core/caches.nix 读取，与 nix.settings 共用一份
  nixConfig = import ./modules/nixos/core/caches.nix;

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

    # Hermes Agent(ai agent,提供 nixosModules.default)
    # 保持独立 nixpkgs pin(与 noctalia/fcitx5-vinput 同惯例):Tier 2 flake,
    # 上游 main 可能破坏构建,用 flake.lock 锁定,升级时先查上游提交
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
    };

    # llm-agents.nix：AI agent 包集合（numtide 维护，每日自动更新）
    # 保持独立 nixpkgs pin：llm-agents 内部 pin 自己的 nixpkgs-unstable，
    # 缓存与 CI 测试组合一一对应；升级用 nix flake lock --update-input llm-agents
    llm-agents.url = "github:numtide/llm-agents.nix";

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
