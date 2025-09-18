{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Niri-centric tools & Waybar
    xwayland-satellite
    bibata-cursors
    waybar
    swayidle
    swaylock
    btop
    brightnessctl
    cava
    gthumb
    networkmanagerapplet
    playerctl
    polkit
    lxqt.lxqt-policykit
    kdePackages.qt6ct
    kdePackages.qtwayland
    rofi
    swww
    wl-clipboard
    xarchiver
  ];

  programs = {
    # Niri itself
    niri.enable  = true;
    #niri.package = pkgs.niri;

    # Enable Waybar (moved here from main config)
    #waybar.enable = true;
  };
}

