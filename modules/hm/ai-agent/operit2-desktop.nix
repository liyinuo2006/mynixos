{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../../pkgs/operit2-desktop.nix { })
  ];
}
