# AWS EC2 云主机：精简 NixOS（基础系统 + SSH + 常用 CLI）。
# 由 nixos-anywhere 远程安装，磁盘布局见 ./disk-config.nix。
# 注意与阿里云 host 的差异：磁盘是 NVMe、缓存用官方源优先（国外机器）。
{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.disko.nixosModules.disko
  ];

  networking.hostName = "aws";
  # VPC 走 DHCP，公网 IP 由 NAT/EIP 映射。
  networking.useDHCP = lib.mkDefault true;
  time.timeZone = "Asia/Shanghai";

  # UEFI + 云上 NVRAM 可能不持久：用可移动回退路径 EFI/BOOT/BOOTX64.EFI。
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  services.openssh = {
    enable = true;
    settings = {
      # 仅密钥登录 root，关闭密码/交互认证
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # 复用 AWS 密钥对（私钥 /home/orion/下载/aws-nix.pem），装完后仍可用它登录。
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRuGFB5F6SHRHgTWG7ne5op18rCBqqNrZF6IPX8JHEUknWu84KaT8E6NfZQiGfgYBL6n7uTpqCqxNl8C0UKGAJcR9S3SR4laUzBwbu0sWs+xc0IStvbfEp/gSMNuo0rSAHM7aEoKVKgmBCYWCENdqGOeP247e0xK+JkFAuNfvtgm3HDekSCuYt8TmUD2pkINes4DJRCtI/lkbfFjqOPW3FvOvxjWxaQ4yWcqI9lwREMGx4RkP4MRH6/B1xFIHu6HwizMC2fkxxgmlJ3YuM+1GERE5ehfWcoYVjIH27vtvDKxnaz7ls00Xp+HF0K7IW6JjzaD2jyaOHE+P2IHpOIaCN aws-nix"
  ];

  # 内存偏紧（~1.9GiB），加 2GiB swapfile 兜底，避免构建/运行 OOM。
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 2048;
    }
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  # 国外主机：官方缓存优先（不同于国内 aliyun 的 tuna 优先）。
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    auto-optimise-store = false;
  };

  # 定期回收 store，避免根卷被历史 generation 撑满。
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  system.stateVersion = "26.05";
}
