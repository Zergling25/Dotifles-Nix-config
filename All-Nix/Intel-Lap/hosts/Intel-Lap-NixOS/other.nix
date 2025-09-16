{ config, keyboardLayout, ... }:
let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  services.libinput.enable = true;
  services.openssh.enable = false;
  services.flatpak.enable = false;
  console.keyMap = keyboardLayout;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  networking.firewall.enable = true;
  system.stateVersion = "25.05";
}

