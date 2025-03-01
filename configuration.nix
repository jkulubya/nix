# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.dell-latitude-5520
      inputs.home-manager.nixosModules.home-manager
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-742887e3-845e-49e1-b1ad-ad9123e65dd6".device = "/dev/disk/by-uuid/742887e3-845e-49e1-b1ad-ad9123e65dd6";
  boot.initrd.luks.devices."luks-742887e3-845e-49e1-b1ad-ad9123e65dd6".keyFile = "/crypto_keyfile.bin";

  networking = {
    hostName = "laptop-dell";

    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  security.rtkit.enable = true;

  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      desktopManager = {
        gnome.enable = true;
      };
      displayManager = {
        gdm.enable = true;
      };
      windowManager.i3.enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    tailscale = {
      enable = true;
      port = 41641;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    logind = {
      extraConfig = ''
        HandlePowerKey=suspend
        IdleAction=suspend
        IdleActionSec=20min
      '';
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.james = {
      isNormalUser = true;
      description = "james";
      extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "docker"
        "dialout" # allows arduino to access serial device
       ];
    };
  };

  # Many programs look at /etc/shells to determine if a user is a "normal" user and not a "system" user.
  # Therefore it is recommended to add the user shells to this list.
  # To add a shell to /etc/shells use the following line in your config: 
  environment.shells = with pkgs; [ zsh ];

  # User does not need to give password when using sudo.
  security.sudo.wheelNeedsPassword = false;

  nix = {
    settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
    };
    gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 5d";
   };
   extraOptions = ''
       experimental-features = nix-command flakes
       keep-outputs          = true
       keep-derivations      = true
   ''; 
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      james = import ./home-manager;
    };
  };

  programs.zsh.enable = true;
  programs.light.enable = true;
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
