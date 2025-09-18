{ config, lib, ... }:
{
  hardware.bluetooth = {
    enable = false;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;

  drivers.amdgpu.enable = false;
  drivers.intel.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
  };

  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  services.fstrim.enable = true;
  services.fstrim.interval = "weekly";

  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 100;
    swapDevices = 1;
    algorithm = "zstd";
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };
  services.thermald.enable = true;

  services.smartd = {
    enable = false;
    autodetect = true;
  };

  services.blueman.enable = false;
  services.fwupd.enable = false;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}

