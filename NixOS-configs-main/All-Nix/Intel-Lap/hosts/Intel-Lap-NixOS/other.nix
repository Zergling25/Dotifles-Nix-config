{ config, keyboardLayout, ... }:
{
  libinput.enable = true;
  openssh.enable = false;
  flatpak.enable = false;
  console.keyMap = keyboardLayout;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  networking.firewall.enable = true;
  system.stateVersion = "25.05";
}

