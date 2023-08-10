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
    azuredatastudio
    firefox
    hstr
    jetbrains.idea-community
    tailscale
    insomnia
    zoom-us
    font-awesome
    gnome.gnome-keyring
    ubuntu_font_family
    gnome.gnome-terminal
    htop
  ];

  programs = {
    home-manager.enable = true;
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
