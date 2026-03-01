# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Kernel Boot Parameters
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;


# Hibernation is not the setting that you want.
## Enable Hibernation ##
#boot.kernelParams = ["resume_offset=23431168"];

#boot.resumeDevice = "/dev/disk/by-uuid/26504187-fee1-4e1d-a555-c8c13404dc33";

#boot.initrd.systemd.enable = true;

#services.power-profiles-daemon.enable = true;

  # Suspend first
#  boot.kernelParams = ["mem_sleep_default=deep"];

  # Define time delay for hibernation
#  systemd.sleep.extraConfig = ''
#    HibernateDelaySec=30m
#    SuspendState=mem
#  '';

#security.protectKernelImage = false;

  # Power Management
  powerManagement.enable = true;

#  swapDevices = [
#    {
#      device = "/var/lib/swapfile";
#      size = 64 * 1024; # 64GB in MB
#    }
#  ];


 hardware.nvidia.powerManagement.enable = true;
#  hardware.nvidia.powerManagement.finegrained = false;

  # Nvidia Drivers
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  systemd.services.nvidia-resume.enable = true;
  systemd.services.nvidia-hibernate.enable = false;
  
  #systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
 
  # Bluetooth hardware configuration

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        #      Experimental = true;  # Enables features like battery level display
        #      FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable IVPN service
  services.ivpn.enable = true;

  # Enable xdg portal
  xdg.portal.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.josh = {
    isNormalUser = true;
    description = "josh";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [
    ];

  };


  programs.steam.enable = true;
  programs.nano.enable = false;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget

    # Install these with home manager
    # Internet
    brave

    # Media
    vlc

    # System
    btop
    bluez
    micro
    git
	neovim

   # Bambu Studio
   bambu-studio
  ];

  # Additional Services
  #services.ivpn.enable = true;

  # Exclusions

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    okular
    kate
    elisa
  ];

# # Firewall exceptions for Bambu Studio
# networking.firewall.extraCommands = ''
#   iptables -I INPUT -p udp -m udp --dports 1990,2021 -j ACCEPT
# '';


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
