{
  pkgs,
  config,
  ...
}:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = false; # 玩游戏要开

    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  hardware.bluetooth.enable = true;

  hardware.enableRedistributableFirmware = true;
  # 如果 WiFi 还是不行，再加下面这行（需要 allowUnfree）
  # hardware.enableAllFirmware = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8821ce
  ];
  boot.kernelModules = [ "8821ce" ];

  hardware.cpu.intel.updateMicrocode = true;
  services.thermald.enable = true;
  services.fwupd.enable = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
