{
  pkgs,
  inputs,
  ...
}:
{
  programs.opencode = {
    enable = true;
    extraPackages = with pkgs; [
      uv
      nixd
      nixfmt
    ];

    settings = {
      permission = {
        edit = "ask";
        bash = "allow";
        webfetch = "allow";
        question = "allow";
      };
      autoupdate = false;
      lsp = {
        nixd = {
          command = [ "nixd" ];
          env = {
            NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
          };
          initialization = {
            nixd = {
              nixpkgs = {
                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
              };
              formatting = {
                command = [ "nixfmt" ];
              };
              options = {
                nixos = {
                  expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.mynixos.options";
                };
                "home-manager" = {
                  expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.mynixos.options.home-manager.users.type.getSubOptions []";
                };
              };
              diagnostic = {
                suppress = [ "sema-extra-with" ];
              };
            };
          };
        };
      };
      formatter = true;
    };

    tui = {
      theme = "system";
      scroll_acceleration.enabled = true; # 启用 macOS 风格的滚动加速，让滚动更平滑自然。启用后，快速滚动时速度会增加，慢速移动时仍保持精确。
      diff_style = "auto";
      mouse = true;
      attention = {
        enabled = true;
        notifications = true;
        sound = true;
        volume = 0.4;
      };
    };

  };
}
