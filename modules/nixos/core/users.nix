{
  ...
}:
{
  users.users.orion = {
    isNormalUser = true;
    description = "Orion";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
