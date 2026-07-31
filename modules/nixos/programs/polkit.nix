{ pkgs, ... }:
{
  # pkexec 需要 setuid 包装才能提权(gparted 等 GUI 提权工具依赖它)
  security.wrappers.pkexec = {
    owner = "root";
    group = "root";
    mode = "u+s";
    source = "${pkgs.polkit}/bin/pkexec";
  };
}
