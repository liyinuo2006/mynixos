# 远程 MCP：mcp-nixos 以 HTTP transport 常驻，供 EasyTier 覆盖网内的设备共享。
# 只绑 EasyTier 网卡 10.144.144.1，不对公网暴露；该 server 无内置鉴权，
# 且 store/flake-inputs 动作能读本机 /nix/store，安全性完全依赖覆盖网隔离
# （network_secret + private_mode），故绝不能把 MCP_NIXOS_HOST 改成 0.0.0.0。
{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.mcp-nixos ];

  systemd.services.mcp-nixos = {
    description = "mcp-nixos HTTP MCP server (shared over EasyTier)";
    wantedBy = [ "multi-user.target" ];
    # tun0 的 IP 由 EasyTier 配置，等它起来后再绑；未就绪时靠 Restart 兜底重试。
    after = [ "network-online.target" "easytier-main.service" ];
    wants = [ "network-online.target" "easytier-main.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      Environment = [
        "MCP_NIXOS_TRANSPORT=http"
        "MCP_NIXOS_HOST=10.144.144.1"
        "MCP_NIXOS_PORT=8000"
        "MCP_NIXOS_STATELESS_HTTP=1" # 多客户端并发，不保留会话状态
      ];
      Restart = "on-failure";
      RestartSec = 5;
      # 云主机内存偏紧（~1.8G），给个上限兜底。
      MemoryMax = "384M";
      # 只读查询、无需提权。
      DynamicUser = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "full";
    };
  };

  # 只在 EasyTier 网卡放行；不要写全局 allowedTCPPorts，否则等于公网暴露。
  networking.firewall.interfaces."tun0".allowedTCPPorts = [ 8000 ];
}
