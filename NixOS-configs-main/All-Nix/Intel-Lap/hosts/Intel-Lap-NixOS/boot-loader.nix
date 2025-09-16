{ config, pkgs, host, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "systemd.mask=systemd-vconsole-setup.service"
    "systemd.mask=dev-tpmrm0.device"
    "nowatchdog"
    "modprobe.blacklist=iTCO_wdt"
  ];

  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ ];
  };

  boot.loader.efi = {
    efiSysMountPoint = "/efi";
    canTouchEfiVariables = true;
  };

  boot.loader.timeout = 1;

  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    gfxmodeBios = "auto";
    memtest86.enable = true;
    extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
    configurationName = "${host}";
  };

  boot.tmp = {
    useTmpfs = false;
    tmpfsSize = "30%";
  };

  boot.plymouth.enable = true;
}

