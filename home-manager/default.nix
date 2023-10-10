# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    ../dotfiles
    ../modules/i3.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      (final: prev: {
        dotnet-sdk_8 = prev.dotnet-sdk_8.overrideAttrs (
          _: { src = builtins.fetchurl {
            url = "https://download.visualstudio.microsoft.com/download/pr/32f2c846-5581-4638-a428-5891dd76f630/ee8beef066f06c57998058c5af6df222/dotnet-sdk-8.0.100-preview.7.23376.3-linux-x64.tar.gz";
            sha256 = "sha256-EIiQMzhQJoLsDSa65/nV/yzhe3+eLgHUzYhdgNmjsAo=";
          };}
        );
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "james";
    homeDirectory = "/home/james";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ 
    azuredatastudio
    firefox
    hstr
    jetbrains.idea-community
    tailscale
    insomnia
    zoom-us
    font-awesome
    ubuntu_font_family
    gnome.gnome-terminal
    htop
    jetbrains.rider
    gnome.nautilus
  ];

  home.file = {
    ".ideavimrc".text=''
      source ~/.vimrc
      '';
  };

  programs = {
    home-manager.enable = true;
    autorandr = {
      enable = true;
      profiles = {
        "desk" = {
          fingerprint = {
            "eDP-1" = "00ffffffffffff0006af994500000000001f010495221378026e8593585892281e505400000001010101010101010101010101010101783780b470382e406c30aa0058c21000001a602c80b470382e406c30aa0058c21000001a000000fe004d43583744804231353648414e000000000000412299001000000a010a2020006f";
            "DP-2" = "00ffffffffffff0010ac82d04c4c54300a1f010380351e78ea2195a756529c26105054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00545037483731333830544c4c0a000000fc0044454c4c20534532343136480a000000fd00384c1e5311000a2020202020200146020317b14c9005040302071601141f121365030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000000000000000000000000003d";
            "HDMI-1" = "00ffffffffffff0010acf7d0495a3230151e010380341d78ea2cc5a45650a1280f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c450009252100001e2a4480a0703827403020350009252100001a000000fc005345323431374847580a202020000000fd00304b1e5412000a2020202020200185020328f14c9005040302071601141f1213230907078301000065030c002000681a00000101304b00023a801871382d40582c450009252100001e011d8018711c1620582c250009252100009e011d007251d01e206e28550009252100001e8c0ad08a20e02d10103e960009252100001800000000000000000000000000000043";
          };
          config = {
            "eDP-1" = {
              enable = true;
              crtc = 0;
              # primary = true;
              position = "1080x1080";
              mode = "1920x1080";
              rate = "60.05";
            };
            "DP-2" = {
              enable = true;
              mode = "1920x1080";
              rate = "60.00";
              rotate = "right";
              position = "0x340";
            };
            "HDMI-1" = {
              enable = true;
              primary = true;
              position = "1080x0";
              mode = "1920x1080";
              rate = "60.00";
            };
          };
        };
        "mobile" = {
          fingerprint = {
            "eDP-1" = "00ffffffffffff0006af994500000000001f010495221378026e8593585892281e505400000001010101010101010101010101010101783780b470382e406c30aa0058c21000001a602c80b470382e406c30aa0058c21000001a000000fe004d43583744804231353648414e000000000000412299001000000a010a2020006f";
          };
          config = {
            "eDP-1" = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0";
              mode = "1920x1080";
              rate = "60.05";
            };
          };
        };
      };
    };
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
    vim = {
      enable = true;
      extraConfig = lib.fileContents ../dotfiles/.vimrc;
      defaultEditor = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
      extraConfig.credential.helper = "libsecret";
    };
    zsh = {
      enable = true;
      shellAliases = {
        hh = "hstr";
      };
      initExtra = ''
        eval "$(direnv hook zsh)"
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "geoffgarside";
      };
    };
  };

  services = {
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = "${pkgs.gnome.gnome-themes-extra}";
    };
    iconTheme = {
      name = "Adwaita";
      package = "${pkgs.gnome.gnome-themes-extra}";
    };
    cursorTheme = {
      name = "Adwaita";
      package = "${pkgs.gnome.gnome-themes-extra}";
    };
  };

  fonts.fontconfig.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
