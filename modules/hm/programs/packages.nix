{
  pkgs,
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

    ripgrep
    tree
    htop
  ];
}
