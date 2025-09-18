{ config, pkgs, host, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "systemd.mask=systemd-vconsole-setup.service"
    "iommu=on"
    "intel_iommu=on"
    "systemd.mask=dev-tpmrm0.device"
    "nowatchdog"
    "modprobe.blacklist=iTCO_wdt"
  ];

  boot.initrd = {
   #availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = ["kvm-intel"];
  };
  boot.loader.timeout = 5;

  boot.loader.systemd-boot.enable = true;
  
  boot.loader.efi.canTouchEfiVariables = true;
}

