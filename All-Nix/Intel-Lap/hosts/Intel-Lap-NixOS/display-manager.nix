{ config, pkgs, user, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      user = "greeter";
      default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
    };
  };
};
}
