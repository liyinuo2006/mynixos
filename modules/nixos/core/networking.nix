{ ... }:
{
  networking = {
    networkmanager.enable = true;
    hostName = "mynixos";
    # 防火墙默认拒绝未经允许的入站连接；桌面软件按需自行声明端口。
    firewall.enable = true;
  };
}
