{
  inputs,
  pkgs,
  ...
}:
let
  # 自定义主题/扩展时从这里取:
  #   spicePkgs.themes.xxx / spicePkgs.extensions.xxx / spicePkgs.apps.xxx
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;

    # 主题:Comfy(深蓝、圆角、暗色;社区主题)
    # 备选见 themes.html:catppuccin / nord / bloom / tokyoNight ...
    theme = spicePkgs.themes.comfy;

    # Comfy 自带配色方案(见其 color.ini):
    #   Comfy / Spotify / Nord / Everforest / Kanagawa / Houjicha / Kitty /
    #   Lunar / Deep / Velvet / Yami / Hikari / catppuccin-{latte,frappe,
    #   macchiato,mocha} / rose-pine{-moon,-dawn} / Mono / Sunset / Neon /
    #   Forest / Sakura / Vaporwave / wal16
    # 默认挑 catppuccin-mocha,和 Mocha 调性一致;按喜好改
    colorScheme = "catppuccin-mocha";

    # 扩展
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts # 隐藏播客
      popupLyrics
      adblockify # 去广告(文档示例名;若构建报错改成 adblock)
      shuffle # 真随机 shuffle+
      showQueueDuration # 队列总时长
      playNext # 「下一首播放
    ];
  };
}
