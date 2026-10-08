{ ... }:
{
  networking = {
    networkmanager.enable = true;
    hostName = "mynixos";

    firewall.enable = true;
    # Operit2 CLI Link 的 HTTP/WebSocket 监听端口。
    firewall.allowedTCPPorts = [ 37195 ];
    # Operit2 CLI Link 的 mDNS 设备发现端口。
    firewall.allowedUDPPorts = [ 5353 ];
    firewall.checkReversePath = "loose";
  };

  # Operit2 的打包与 Link 服务来自 operit2-flake（见 hosts/*/default.nix）。
}
