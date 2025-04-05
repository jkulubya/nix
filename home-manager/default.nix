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
        "desk" = {
          fingerprint = {
            "eDP-1" = "00ffffffffffff0006af994500000000001f010495221378026e8593585892281e505400000001010101010101010101010101010101783780b470382e406c30aa0058c21000001a602c80b470382e406c30aa0058c21000001a000000fe004d43583744804231353648414e000000000000412299001000000a010a2020006f";
            "DP-2" = "00ffffffffffff0010ac82d04c4c54300a1f010380351e78ea2195a756529c26105054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00545037483731333830544c4c0a000000fc0044454c4c20534532343136480a000000fd00384c1e5311000a2020202020200146020317b14c9005040302071601141f121365030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000000000000000000000000003d";
            "HDMI-1" = "00ffffffffffff000469a123c41e03003417010380331d782a5ea5a2554da026115054b7ef00d1c0b30081408180950081c0714f0101023a801871382d40582c4500fd1e1100001e000000ff0044434c4d54463230343438340a000000fd00324b185311000a202020202020000000fc004153555320504132333851520a013f020322714f0102031112130414050e0f1d1e1f90230917078301000065030c0010008c0ad08a20e02d10103e9600fd1e11000018011d007251d01e206e285500fd1e1100001e011d00bc52d01e20b8285540fd1e1100001e8c0ad090204031200c405500fd1e1100001800000000000000000000000000000000000000000069";
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
              position = "0x0";
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
      package = "${pkgs.gnome-themes-extra}";
    };
    iconTheme = {
      name = "Adwaita";
      package = "${pkgs.gnome-themes-extra}";
    };
    cursorTheme = {
      name = "Adwaita";
      package = "${pkgs.gnome-themes-extra}";
    };
  };

  fonts.fontconfig.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
