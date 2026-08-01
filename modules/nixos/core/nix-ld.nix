{
  pkgs,
  ...
}:
{
  # nix-ld：在 /lib64 等标准位置提供动态链接器，让未打包的动态链接二进制
  # （如机场提供的 FlashFoxLite GUI）能直接在 NixOS 上运行。
  # 启用后自动设置 NIX_LD / NIX_LD_LIBRARY_PATH 会话变量，
  # 并把下列 libraries 合并到 /run/current-system/sw/share/nix-ld/lib。
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # FlashFoxLite (Flutter GTK3) 缺失的库
      gtk3
      gdk-pixbuf
      glib
      pango
      cairo
      harfbuzz
      at-spi2-atk
      fontconfig
      libepoxy
      # 托盘图标 (libayatana-appindicator3)
      libayatana-appindicator
      libayatana-ido
      libayatana-indicator
      libdbusmenu-glib
      # C++ 运行时 (libstdc++)
      stdenv.cc.cc.lib
    ];
  };
}
