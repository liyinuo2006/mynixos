{ ... }:
{

  security.polkit = {
    enable = true; # polkitd 目前由 services.udisks2 隐式拉起,显式声明以免依赖变动时失效
    enablePkexecWrapper = true; # 启用 setuid pkexec 包装(gparted 等 GUI 提权工具依赖它)
  };

}
