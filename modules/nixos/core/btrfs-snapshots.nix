{ ... }:
{
  services.btrbk.instances."btrbk" = {
    onCalendar = "0/2"; # 每 2 小时整点拍一次
    settings = {
      snapshot_preserve_min = "1d"; # 最近 1 天无条件保留
      snapshot_preserve = "3d"; # 总共只保留最近 3 天的快照
      volume."/" = {
        subvolume = "/home";
        snapshot_dir = "/snapshots"; # 复用已有 @snapshots 子卷
      };
    };
  };
}
