{ config, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.pulseaudio.enable = false;
  services.udev.enable = true;
  services.envfs.enable = true;
  services.dbus.enable = true;
}

