# ============================================================================
# 废弃：闪狐 FlashFox Lite（2026-09 停用，机场跑路，软件与订阅均不可用）
#
# 本文件是「删除前」的原始配置快照，放在垃圾桶里等系统切换确认无误后再删。
# 本目录不被任何 default.nix 导入，不要从 _trash 里 import 任何东西。
#
# ---- 如果要恢复到未删除的状态，按以下步骤操作 ----
#
# 1) 把本文件移回原位：
#      git mv modules/_trash/nixos/flashfox-lite.nix \
#             modules/nixos/programs/flashfox-lite.nix
#
# 2) 在 modules/nixos/programs/default.nix 的 imports 里加回：
#      ./flashfox-lite.nix
#
# 3) 在 flake.nix 的 inputs 里加回（并跑 nix flake lock 重新拉取）：
#      flashfox-lite = {
#        url = "github:liyinuo2006/flashfox-lite-flake";
#        inputs.nixpkgs.follows = "nixpkgs";
#      };
#
# 4) 切换系统：
#      sudo nixos-rebuild switch --flake .#mynixos
#
# 注意：机场已跑路，即使恢复配置也无可用订阅；运行时数据在
#       ~/.local/share/com.ffclient.app/，必要时自行清理残留 TUN（Meta 接口等）。
# ============================================================================
{
  inputs,
  ...
}:
{
  imports = [
    inputs.flashfox-lite.nixosModules.default
  ];

  programs.flashfox-lite = {
    enable = true;
    enableTun = true;
  };
}