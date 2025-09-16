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

  fstrim.enable = true;
  fstrim.interval = "weekly";

  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };
  services.thermald.enable = true;

  smartd = {
    enable = false;
    autodetect = true;
  };

  blueman.enable = false;
  fwupd.enable = false;
  upower.enable = true;
  gnome.gnome-keyring.enable = false;
  power-profiles-daemon.enable = true;
}

