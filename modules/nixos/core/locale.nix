{
  pkgs,
  ...
}:
{
  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console.keyMap = "us";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono

      corefonts
      vista-fonts
      vista-fonts-chs
      vista-fonts-cht

      lxgw-wenkai
      lxgw-wenkai-screen
      lxgw-neoxihei
      lxgw-fusionkai
      sarasa-gothic

    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "Sarasa Gothic SC"
          "LXGW WenKai"
          "Noto Sans CJK SC"
        ];
        serif = [
          "Noto Serif CJK SC"
        ];
        monospace = [
          "JetBrainsMono Nerd Font Mono"
          "Noto Sans Mono CJK SC"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };

}
