_: {
  programs.fish = {
    enable = true;

    interactiveShellInit = "
    set -g fish_greeting
    ";

    shellAliases = {
      ll = "ls -lh";
      la = "ls -lha";
      "..." = "cd ../..";
    };

  };
  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    presets = [ "nerd-font-symbols" ];
  };
}
