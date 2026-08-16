{ ... }: {
  services.udisks2.enable = true; # 事实上，根据源码 gvfs 的启用会自动启用udisks2。
  services.gvfs.enable = true;
}
