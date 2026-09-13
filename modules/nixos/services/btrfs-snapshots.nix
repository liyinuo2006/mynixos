{ ... }:
{
  services.btrbk.instances."btrbk" = {
    onCalendar = "*-*-* 00/6:00:00"; # 每 6 小时拍一次
    settings = {
      # 只无条件保留最新一个快照（btrbk 按整日算，"1d" 会多留一整天）
      snapshot_preserve_min = "latest";
      # 再按「每天第一个快照」保留 7 天，稳定后约 7~8 个
      snapshot_preserve = "7d";
      volume."/" = {
        subvolume = "/home";
        snapshot_dir = "/snapshots"; # 复用已有 @snapshots 子卷
      };
    };
  };
}
