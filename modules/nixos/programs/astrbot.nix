# AstrBot + NapCat：直接用官方 OCI 镜像跑，不塞进 Nix 闭包。
#
# 为什么用容器而不是打成 Nix 包：AstrBot 依赖极重（Python 3.12 + pandas/faiss/
# python-telegram-bot/wechatpy/markitdown… 另外还要 Node.js、ffmpeg、noto-cjk 字体），
# 而且插件市场会在运行时 pip 装插件、dashboard 缺资源时还会去 GitHub 下载。这些都和
# Nix store 的不可变模型冲突，跑官方镜像最省心。
#
# 组件：
#   * astrbot  soulter/astrbot         WebUI:6185，OneBot v11 WS 服务:6199
#   * napcat   mlikiowa/napcat-docker  MODE=astrbot 会写入 onebot11.json，让 NapCat
#              作为 WS 客户端连 ws://astrbot:6199/ws；自带 WebUI:6099
#
# 网络：两个容器都接 Podman 默认桥网络，靠容器名互相解析（下面开了 dns_enabled）。
#
# 数据：bind 到 /var/lib/astrbot/ 下，方便备份/查看。napcat 与 astrbot 共享 data 目录
#       是照抄上游 NapCat 的 compose，保持与官方一致。
#
# 国内网络直接拉不到镜像时，把 image 换成本段注释里的 DaoCloud 镜像地址即可，例如
#   image = "m.daocloud.io/docker.io/soulter/astrbot:latest";
#   image = "m.daocloud.io/docker.io/mlikiowa/napcat-docker:latest";
{ config, ... }:
let
  # NapCat 的入口脚本把 NAPCAT_UID/GID 直接喂给 `usermod -u`/`groupmod -g`，只认数字，
  # 所以从 orion 的 uid/gid 取数值，而不是写用户名。
  uid = toString config.users.users.orion.uid;
  gid = toString config.users.groups.${config.users.users.orion.group}.gid;
in
{
  virtualisation.oci-containers = {
    # stateVersion ≥ 22.05 时 backend 默认就是 podman，这里显式写出以免以后默认变化
    backend = "podman";

    containers = {
      astrbot = {
        image = "soulter/astrbot:latest";
        # 只发布 WebUI 6185 到宿主。OneBot v11 的 6199 走容器网络给 napcat 用，
        # 不暴露到宿主：否则局域网里任何人都能直接连上冒充 OneBot 客户端发消息。
        ports = [ "6185:6185" ];
        environment.TZ = "Asia/Shanghai";
        volumes = [
          "/var/lib/astrbot/data:/AstrBot/data"
          "/etc/localtime:/etc/localtime:ro" # 容器内时间与宿主一致
        ];
        # 与上游 compose 的 security_opt 保持一致
        extraOptions = [ "--security-opt=no-new-privileges" ];
      };

      napcat = {
        image = "mlikiowa/napcat-docker:latest";
        dependsOn = [ "astrbot" ]; # OneBot WS 客户端，等 AstrBot 起来再启动
        environment = {
          # 预置模板：自动生成 onebot11.json，连 ws://astrbot:6199/ws
          MODE = "astrbot";
          # 容器内以该 uid/gid 写文件，与宿主 orion 对齐，便于以后直接查看数据
          NAPCAT_UID = uid;
          NAPCAT_GID = gid;
        };
        ports = [ "6099:6099" ]; # NapCat WebUI（扫码登录 QQ 用）
        volumes = [
          "/var/lib/astrbot/data:/AstrBot/data"
          "/var/lib/astrbot/napcat/config:/app/napcat/config"
          "/var/lib/astrbot/ntqq:/app/.config/QQ" # QQ 登录态
        ];
      };
    };
  };

  # 开启 Podman 默认网络上的容器名 DNS（aardvark-dns），napcat 才能解析到 astrbot。
  # 不设此项时默认不开，模块也不会放行 podman0 上的 53/UDP。
  # （oci-containers 见 backend=podman 会自动 enable，这里显式写出更清楚。）
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 建持久化目录并归属 orion（用数值 uid/gid，避免写不存在的组名）：
  # 容器内降权到 uid=orion 的进程才写得进去。
  systemd.tmpfiles.rules = [
    "d /var/lib/astrbot 0755 ${uid} ${gid} -"
    "d /var/lib/astrbot/data 0755 ${uid} ${gid} -"
    "d /var/lib/astrbot/napcat 0755 ${uid} ${gid} -"
    "d /var/lib/astrbot/napcat/config 0755 ${uid} ${gid} -"
    "d /var/lib/astrbot/ntqq 0755 ${uid} ${gid} -"
  ];

  # Podman 发布端口时会自行插入转发规则，通常已绕过 NixOS firewall；这里仍显式放行，
  # 一是便于阅读，二是万一以后改用 host 网络也不会漏。
  networking.firewall.allowedTCPPorts = [ 6185 6099 ];
}
