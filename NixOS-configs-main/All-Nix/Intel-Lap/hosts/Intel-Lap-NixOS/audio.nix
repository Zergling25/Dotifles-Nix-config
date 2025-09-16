{ config, ... }:
{
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  pulseaudio.enable = false;
  udev.enable = true;
  envfs.enable = true;
  dbus.enable = true;
}

