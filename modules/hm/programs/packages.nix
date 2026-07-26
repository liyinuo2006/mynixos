{
  pkgs,
  ...
}:
let
  wechat-wrapped = pkgs.symlinkJoin {
    name = "wechat";
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
in

{
  home.packages = with pkgs; [

    wechat-wrapped
    qq

    wpsoffice-cn
    google-chrome

    nautilus

    ripgrep
    tree
    htop
  ];
}
