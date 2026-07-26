{
  pkgs,
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
  };
}
