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
    docker-compose
    firefox
    hstr
    tailscale
    insomnia
    zoom-us
    font-awesome
    ubuntu_font_family
    gnome-terminal
    htop
    jetbrains.rider
    nautilus
    kubectl
    k9s
    inetutils
    kubernetes-helm
    spicedb-zed
    git-credential-manager
    unzip
    pulumi-bin
    xclip
    kdePackages.kmines
    alsa-utils
    stgit
    dotnetCorePackages.dotnet_9.sdk
    guitarix
    scarlett2
    alsa-scarlett-gui
    qjackctl
    pavucontrol
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
        "docked" = {
          fingerprint = {
            "DP-10" = "00ffffffffffff0030aeb463000000002c220104b5351e783ea3d5ab524f9d240f5054adcf00714f8180818a9500a9c0a9cfb300d1c0565e00a0a0a02950302035000f282100001a000000fc00503234712d33300a2020202020000000fd00324c1c701e000a202020202020000000ff005639304539374c410a2020202001eb02031ff14790040302011f1323090f0783010000e305c000e60605015252498c0ad08a20e02d10103e96000f2821000018011d007251d01e206e2855000f282100001e023a801871382d40582c45000f282100001ecc7400a0a0a01e50302035000f282100001a0000000000000000000000000000000000000000000000000c";
            "DP-11" = "00ffffffffffff0030aeb463000000002c220104b5351e783ea3d5ab524f9d240f5054adcf00714f8180818a9500a9c0a9cfb300d1c0565e00a0a0a02950302035000f282100001a000000fc00503234712d33300a2020202020000000fd00324c1c701e000a202020202020000000ff005639304539374b520a2020202001db02031ff14790040302011f1323090f0783010000e305c000e60605015252498c0ad08a20e02d10103e96000f2821000018011d007251d01e206e2855000f282100001e023a801871382d40582c45000f282100001ecc7400a0a0a01e50302035000f282100001a0000000000000000000000000000000000000000000000000c";
            "eDP-1" = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
          };
          config = {
            "eDP-1" = {
              enable = true;
              crtc = 0;
              # primary = true;
              position = "1280x0";
              mode = "2256x1504";
              rate = "60.00";
            };
            "DP-10" = {
              enable = true;
              primary = true;
              position = "0x1504";
              mode = "2560x1440";
              rate = "60.00";
            };
            "DP-11" = {
              enable = true;
              position = "2560x1504";
              mode = "2560x1440";
              rate = "60.00";
            };
          };
        };
        "undocked" = {
          fingerprint = {
            "eDP-1" = "00ffffffffffff0009e5ca0b000000002f200104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a0073";
          };
          config = {
            "eDP-1" = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0x0";
              mode = "2256x1504";
              rate = "60.00";
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
      packageConfigurable = pkgs.vim-full;
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
      extraConfig.credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      extraConfig.credential.credentialStore = "secretservice";
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

  fonts.fontconfig.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
