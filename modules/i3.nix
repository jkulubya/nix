{ config, lib, pkgs, ... }: 
let 
  mod = "Mod4";
in
{
  services = {
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };

    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
      xautolock.enable = true;
    };
  };

  xsession = {
    enable = true;
    initExtra = ''
      eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    '';
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "${mod}";
        fonts = {
          names = [ "Ubuntu" "FontAwesome 6 Free"];
          size = 11.0;
        };
        terminal = "gnome-terminal";
        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
            fonts = {
              size = 13.0;
            };
          }
        ];
        keybindings = lib.mkOptionDefault {
          "XF86AudioRaiseVolume" = "exec amixer -q sset Master 5%+ unmute";
          "XF86AudioLowerVolume" = "exec amixer -q sset Master 5%- unmute";
          "XF86AudioMute" = "exec amixer -q sset Master toggle";
          "XF86MonBrightnessUp" = "exec --no-startup-id light -A 5";
          "XF86MonBrightnessDown" = "exec --no-startup-id light -U 5";
          "Control+${mod}+l" = "exec --no-startup-id xss-lock -- i3lock";

          # "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          # "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
          # "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";
          
          # # Focus
          # "${mod}+j" = "focus left";
          # "${mod}+k" = "focus down";
          # "${mod}+l" = "focus up";
          # "${mod}+semicolon" = "focus right";    #   #   # # Move
          # "${mod}+Shift+j" = "move left";
          # "${mod}+Shift+k" = "move down";
          # "${mod}+Shift+l" = "move up";
          # "${mod}+Shift+semicolon" = "move right";    #   #   # # My multi monitor setup
          # "${mod}+m" = "move workspace to output DP-2";
          # "${mod}+Shift+m" = "move workspace to output DP-5";
        };
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        icons = "awesome6";
        settings = {
          theme = {
            theme = "slick";
            overrides = {
              separator = "";
            };
          };
        };
        blocks = [
          {
            block = "cpu";
          }
          {
            alert = 10.0;
            block = "disk_space";
            format = " $icon $available.eng(w:2) available ";
            info_type = "available";
            interval = 20;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
            format = " $icon $mem_total_used_percents.eng(w:2) memory used ";
            format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
          }
          {
            block = "sound";
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d %b %R') ";
            interval = 5;
          }
          {
            block = "battery";
          }
       ];
      };
    };
  };
}
