{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.deepseek-harness.homeModules.default ];

  programs.dsh = {
    enable = true;
    profiles.web-ui = {
      bundles = [
        pkgs.dsh.bundles.web-app
        pkgs.dsh.bundles.web-ui
      ];
      mode = "mutable";
    };

    defaultProfile = config.programs.dsh.profiles.web-ui.materializedName;
  };

  services.dsh = {
    enable = true;
    profile = config.programs.dsh.profiles.web-ui.materializedName;
    environmentFile = "${config.home.homeDirectory}/.config/sops-nix/secrets/dsh-env";
    port = 3080;
  };

  systemd.user.services.dsh-web.Unit.After = [ "sops-nix.service" ];
}
