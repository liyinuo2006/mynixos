{
  ...
}:
{

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 30;
    useOSProber= true;
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
