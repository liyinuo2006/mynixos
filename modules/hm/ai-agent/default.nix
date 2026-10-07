_: {
  imports = [
    ./opencode2.nix
    ./hermes.nix
    ./dsh.nix
    # Operit2 CLI 与 GUI 共用 Linux D-Bus 单例，当前只自动安装 GUI。
    ./operit2-desktop.nix
  ];
}
