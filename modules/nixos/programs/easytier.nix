# EasyTier 组网（本机）：网络锚点在 aliyun（公网 114.215.126.192），手机 App 亦接入同一网络。
#
# 网络口令不进 Nix store：settings.network_secret 只写 ${ET_NETWORK_SECRET} 占位符，
# 由 sops 渲染的 EnvironmentFile（见 modules/nixos/security/sops.nix 的 easytier-env 模板）
# 在运行时注入；easytier-core 读取 -c 配置文件时会展开 ${...}（未加 --disable-env-parsing）。
#
# 注意与两个代理 TUN 的共存：EasyTier 只为本网络网段 10.144.144.0/24 建路由，
# 一般不与闪狐(Meta)/Clash(Mihomo) 的全局 TUN 冲突；若 Clash auto-route 吞掉该网段，
# 需在 Clash 侧给 10.144.144.0/24 加直连/绕过规则。
{ config, ... }:

{
  services.easytier.enable = true;

  services.easytier.instances.main = {
    environmentFiles = [ config.sops.templates."easytier-env".path ];

    settings = {
      instance_name = "ctmiop";
      hostname = "vostro-3420";
      network_name = "ctmiop";
      network_secret = "\${ET_NETWORK_SECRET}"; # 运行时展开，明文不落 store
      ipv4 = "10.144.144.2/24";
      # listeners 用模块默认 tcp+udp 0.0.0.0:11010
      peers = [ "tcp://114.215.126.192:11010" ];
    };

    extraSettings.flags = {
      accept_dns = true;
      private_mode = true;
    };
  };

  # P2P 直连需要入站 11010（内网 NAT 后面的入站能否到达取决于路由器）
  networking.firewall.allowedTCPPorts = [ 11010 ];
  networking.firewall.allowedUDPPorts = [ 11010 ];
}
