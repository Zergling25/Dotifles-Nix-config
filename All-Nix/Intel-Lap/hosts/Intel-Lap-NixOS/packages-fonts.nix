{ pkgs, inputs, ... }:

{
  imports = [ ./niri.nix ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # System Utilities
    curl
    cpufrequtils
    ffmpeg
    glib
    gsettings-qt
    git
    killall
    libappindicator
    libnotify
    pciutils
    vim
    wget
    xdg-user-dirs
    xdg-utils
    dconf-editor

    # Terminal & CLI
    alacritty
    helix
    wezterm
    fastfetch

    # Apps for your Laptop
    gparted
    kdePackages.kate
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk-sans
    jetbrains-mono
    font-awesome
    terminus_font
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.fantasque-sans-mono
  ];
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  programs = {
    # Browsers
    firefox.enable   = true;

    # Version Control
    git.enable       = true;

    # Network Manager tray icon
    nm-applet.indicator = true;

    # File manager
    thunar.enable  = true;
    thunar.plugins = with pkgs.xfce; [
      exo
      mousepad
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];
    
    # Optional Services
    virt-manager.enable   = true;
    dconf.enable          = true;
    #seahorse.enable       = false;

    # GPG/SSH Agent
    gnupg.agent = {
      enable           = false;
      enableSSHSupport = false;
    };
  };

  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };
}

