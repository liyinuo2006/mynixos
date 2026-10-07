{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../../pkgs/operit2-cli.nix { })
  ];
}
