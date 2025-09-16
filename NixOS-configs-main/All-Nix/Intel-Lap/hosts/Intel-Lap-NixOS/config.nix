{ config, pkgs, username, host, options, lib, inputs, system, ... }:
let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  imports = [
    ./hardware-settings.nix
    ./boot-loader.nix
    ./display-manager.nix
    ./networking.nix
    ./audio.nix
    ./polkit.nix
    ./nix-settings.nix
    ./other.nix
    ./users.nix
    ./packages-fonts.nix
    ./qemu-kvm.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  
}

