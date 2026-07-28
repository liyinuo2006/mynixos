# Zen 浏览器(0xc000022070/zen-browser-flake,beta 渠道)
# 当前为最小配置:先在图形界面中调教,后续再逐步转为 Nix 声明
# 声明式配置参考:https://github.com/0xc000022070/zen-browser-flake/tree/main/examples
{ inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    # setAsDefaultBrowser = true; # 需要设为默认浏览器时取消注释
  };
}
