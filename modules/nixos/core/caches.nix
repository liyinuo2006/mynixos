# 缓存镜像与信任密钥的唯一维护点：
# flake.nix 的 nixConfig 与 modules/nixos/core/nix.nix 的 nix.settings 都从这里读取。
# 新增带 cachix 缓存的包时，只改这一个文件。
{
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
  ];
}
