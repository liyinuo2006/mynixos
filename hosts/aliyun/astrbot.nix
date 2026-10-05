# AstrBot + NapCat：直接用官方 OCI 镜像跑，不塞进 Nix 闭包。
# 从桌面迁来（旧配置见 modules/_trash/nixos/astrbot.nix），云主机上的差异：
#   - 目录属主用 root（容器以 root 运行；本机没有 orion 用户）
#   - 6185/6099 都对公网开放：请务必改掉 AstrBot 面板默认密码、给 NapCat WebUI 设 token
#   - ntqq 登录态未迁移，首次用 6099 WebUI 扫码登录
#
# 组件与机制同桌面版：astrbot(WebUI:6185, OneBot WS:6199) + napcat(MODE=astrbot, WebUI:6099)。
# 镜像走 DaoCloud 镜像站；若不可用换回 soulter/astrbot:latest、mlikiowa/napcat-docker:latest。
{ ... }:
{
  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      astrbot = {
        image = "m.daocloud.io/docker.io/soulter/astrbot:latest";
        ports = [ "6185:6185" ];
        environment.TZ = "Asia/Shanghai";
        volumes = [
          "/var/lib/astrbot/data:/AstrBot/data"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [ "--security-opt=no-new-privileges" ];
      };

      napcat = {
        image = "m.daocloud.io/docker.io/mlikiowa/napcat-docker:latest";
        dependsOn = [ "astrbot" ];
        environment.MODE = "astrbot";
        ports = [ "6099:6099" ];
        volumes = [
          "/var/lib/astrbot/data:/AstrBot/data"
          "/var/lib/astrbot/napcat/config:/app/napcat/config"
          "/var/lib/astrbot/ntqq:/app/.config/QQ"
        ];
      };
    };
  };

  # aardvark-dns：napcat 才能用容器名 astrbot 解析到 AstrBot。
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/astrbot 0755 root root -"
    "d /var/lib/astrbot/data 0755 root root -"
    "d /var/lib/astrbot/napcat 0755 root root -"
    "d /var/lib/astrbot/napcat/config 0755 root root -"
    "d /var/lib/astrbot/ntqq 0755 root root -"
  ];

  networking.firewall.allowedTCPPorts = [ 6185 6099 ];
}
