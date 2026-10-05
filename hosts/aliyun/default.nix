# 阿里云 ECS 云主机：精简 NixOS（基础系统 + SSH + 常用 CLI）。
# 由 nixos-anywhere 远程安装，磁盘布局见 ./disk-config.nix。
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
    ./astrbot.nix
    inputs.disko.nixosModules.disko
  ];

  networking.hostName = "aliyun";
  # 阿里云 VPC 走 DHCP，公网 IP 由 NAT 映射，无需 cloud-init 配网。
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

  # 复用阿里云密钥对（私钥 ~/.ssh/aliyun.pem），装完后仍可用它登录。
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnLPyOSX/kKEARUgBeGNbXej68d8akbLNxjPjGHWkjKYtY/iVEZFK6wYIpSUWH2WJadwEfQflYuAMQcdho++zTEXbjHS6PFT0QCElMR491VvTmqnNIBSSzh6D9ZUjTamBqD9rHXQSIQNhYYMdZoMLj6MIxFzG+Qebeo/2HKdhS9D+dgpA/ymsvMf4CXUrViGpXT3DmIhN7WWEmyz/5LJRy2XlB1P61FI/4lWL9YEmn2PSeIEUn1N9i5g1ozd+DGO/xVh7pBCvv7ynJc+3hxjue44JsuyIUZMEwwkRWuoso3y0lN/icmxfT2yGSXyqr2FT6MuAl70FgLVeAYRzGthij aliyun-ecs"
  ];

  # 内存偏紧（~1.8GiB），加 2GiB swapfile 兜底，避免构建/运行 OOM。
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 2048;
    }
  ];

  services.qemuGuest.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  # 缓存与信任密钥沿用 flake.nix 的唯一维护点
  # （与 modules/nixos/core/nix.nix 同源），便于日后在服务器上直接 rebuild。
  nix.settings = let
    caches = (import ../../flake.nix).nixConfig;
  in {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = caches.substituters;
    trusted-public-keys = caches.trusted-public-keys;
    trusted-users = [
      "root"
      "@wheel"
    ];
    auto-optimise-store = false;
  };

  # 定期回收 store，避免 40G 系统盘被历史 generation 撑满。
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  system.stateVersion = "26.05";
}
