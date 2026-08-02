{ ... }:
{
  networking = {
    networkmanager.enable = true;
    hostName = "mynixos";

    firewall.enable = true;
    firewall.checkReversePath = "loose";
  };

}
