{
  inputs,
  ...
}:
{
  imports = [
    inputs.flashfox-lite.nixosModules.default
  ];

  programs.flashfox-lite.enable = true;
}
