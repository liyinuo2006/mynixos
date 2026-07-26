{ pkgs, ... }:
{
  nixpkgs.config = {
    # allowBroken = true;
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
  ];
}
