{ pkgs, username, ... }:

{
  users = {
    mutableUsers = true;

    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "a-user";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video"
        "input"
        "audio"
      ];

      packages = with pkgs; [
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ fzf ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    ohMyZsh = {
      enable = true;
      plugins = [];
      theme = "gnzh";
    };

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    promptInit = ''
      fastfetch

      source <(fzf --zsh);
      HISTFILE=~/.zsh_history;
      HISTSIZE=10000;
      SAVEHIST=10000;
      setopt appendhistory;
    '';
  };
}

