{
  inputs,
  pkgs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.text;

    # text/color.ini 段名(区分大小写):
    #   Spotify | Spicetify | CatppuccinMocha | CatppuccinMacchiato | CatppuccinLatte
    #   Dracula | Gruvbox | GruvboxHard | Kanagawa | Nord | Rigel
    #   RosePine | RosePineMoon | RosePineDawn | Solarized
    #   TokyoNight | TokyoNightStorm | ForestGreen
    #   EverforestDarkHard | EverforestDarkMedium | EverforestDarkSoft
    colorScheme = "CatppuccinMocha";

    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      adblock
    ];
  };
}
