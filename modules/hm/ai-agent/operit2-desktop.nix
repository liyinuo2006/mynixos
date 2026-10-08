{ ... }:
{
  # 由 operit2-flake 的 homeModules.default 提供选项。
  # 只安装 GUI；CLI 由服务器的 services.operit2-link 常驻运行，本机不装。
  programs.operit2-desktop.enable = true;
}
