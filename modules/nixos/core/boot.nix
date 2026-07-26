{
  ...
}:
{

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
    editor = false;
  };

  boot.kernelParams = [
    "loglevel=5"
    "nowatchdog"
    "modprobe.blacklist=iTCO_wdt"
  ];

  boot.zswap = {
    enable = true;
  };

}
