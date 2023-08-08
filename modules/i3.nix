{ config, lib, pkgs, ... }: {
  services = {
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
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
        modifier = "Mod4";
        fonts = {
          names = ["DejaVu Sans Mono, FontAwesome 6 Free"];
        };    
        # keybindings = lib.mkOptionDefault {
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
          # };
      };
    };
  };
}
