{ ... } : 
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = "unset";
      switch-applications-backward = "unset";
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };
    "org/gnome/Console" = {
      font-scale = 1.2000000000000002;
    };
    "org/gnome/desktop/sound" = {
      event-sounds = false;
      input-sounds = false;
    };
  };
}
