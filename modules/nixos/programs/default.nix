{ ... }:
{
  imports = [
    ./clash.nix
    ./flashfox-lite.nix
    ./nix-ld.nix
    ./cua-driver.nix
    ./packages.nix
    ./nautilus.nix
    ./matlab.nix
    ./kdeconnect.nix
    # astrbot 已迁到云主机，见 hosts/aliyun/astrbot.nix
  ];
}
