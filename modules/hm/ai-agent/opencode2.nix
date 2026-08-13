{ pkgs, inputs, ... }:
{
  # opencode2 = OpenCode v2 预览版（llm-agents.nix 每日更新，npm next 通道 @opencode-ai/cli）
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2
  ];
}
