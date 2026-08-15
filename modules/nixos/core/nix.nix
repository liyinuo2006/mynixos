{
  inputs,
  config,
  ...
}:
let
  # 缓存与信任密钥唯一维护点在 flake.nix 的 nixConfig
  caches = (import ../../../flake.nix).nixConfig;
in
{

  nix = {

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # GitHub token 由 sops 模板渲染后经 !include 引入（nix.conf 官方 include 特性）：
    # access-tokens 只支持字面值（NixOS/nix#6536 未实现 file 读取），
    # 模板路径引用 security/sops.nix 的 nix-access-tokens，token 明文不落 Nix store。
    extraOptions = ''
      !include ${config.sops.templates."nix-access-tokens".path}
    '';

    settings = {

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = caches.substituters;
      trusted-public-keys = caches.trusted-public-keys;
      trusted-users = [
        "@wheel"
        "root"
      ];
      auto-optimise-store = false;
    };

    gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 7d";
    };

    # 定期合并内容相同的 store 文件，节省磁盘空间。
    optimise = {
      automatic = true;
      dates = [ "3:45" ];
    };
  };
}
