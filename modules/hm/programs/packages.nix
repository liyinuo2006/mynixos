{
  pkgs,
  inputs,
  ...
}:
let
  wechat-wrapped = pkgs.symlinkJoin {
    name = "${pkgs.wechat.pname or "wechat"}-${pkgs.wechat.version}";
    paths = [ pkgs.wechat ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/wechat \
        --set QT_QPA_PLATFORM xcb \
        --set QT_IM_MODULE fcitx \
        --set GTK_IM_MODULE fcitx \
        --set QT_AUTO_SCREEN_SCALE_FACTOR 1
    '';
  };

  wps-wrapped = pkgs.symlinkJoin {
    name = "${pkgs.wpsoffice-cn.pname or "wpsoffice-cn"}-${pkgs.wpsoffice-cn.version}";
    paths = [ pkgs.wpsoffice-cn ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in wps wpp et wpspdf; do
        wrapProgram $out/bin/$bin \
          --set QT_QPA_PLATFORM xcb \
          --set QT_FONT_DPI 144 \
          --set QT_IM_MODULE fcitx \
          --set GTK_IM_MODULE fcitx \
          --set XMODIFIERS @im=fcitx
      done
    '';
  };

in

{
  home.packages = with pkgs; [

   wechat-wrapped
   qq
    wps-wrapped
    google-chrome

    nautilus
    motrix-next

    # Noctalia 模板主题依赖:GTK 基础主题 + Qt 配色工具
    adw-gtk3
    qt6Packages.qt6ct

    ripgrep
    tree
    btop
    fastfetch
    rsync

    #压缩与解压缩
    unzip
    zip
    p7zip
    # rar 包同时提供 rar 与 unrar 命令，无需单独装 unrar
    rar
    gnutar
    gzip
    xz
    bzip2
    swayimg
    nautilus-python

    #视频工具
    ffmpeg-full
    mpv
    obs-studio
    yt-dlp
    mediainfo

    # AyuGram:Telegram 增强客户端(Ghost Mode、防撤回等)
    inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop

  ];
}
