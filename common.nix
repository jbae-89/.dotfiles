# common.nix
# Shared configuration applied to ALL hosts.
# Put machine-specific settings (GPU drivers, hostname, power) in hosts/<n>/<n>.nix
{ config, pkgs, ... }:

{
  # -- Bootloader -------------------------------------------------------------
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # -- Nix --------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  # -- Networking -------------------------------------------------------------
  networking.networkmanager.enable = true;

  # -- Locale & Time ----------------------------------------------------------
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  # -- Desktop: Cinnamon + LightDM --------------------------------------------
  services.xserver = {
    enable                      = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    xkb = { layout = "us"; variant = ""; };
    excludePackages = with pkgs; [ xterm ];
  };

  services.displayManager.defaultSession = "cinnamon";
  services.libinput.enable               = true;

services.xserver.displayManager.sessionCommands = ''
  if test "$XDG_CURRENT_DESKTOP" = "Cinnamon"; then
    gsettings set org.cinnamon.desktop.screensaver show-media-controls false
  fi
'';  
  environment.cinnamon.excludePackages = with pkgs; [ 
    gnome-terminal
    # gnome-screenshot
  ];

# Add this to your configuration.nix
environment.variables = {
  XCURSOR_SIZE = "24"; # Adjust to your preferred size
  XCURSOR_THEME = "Adwaita"; # Or whatever theme you use
};


services.dbus.enable = true;

qt = {
  enable = true;
  platformTheme = "gtk2";
  style = "gtk2";
};


  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gtk ];
    config.x-cinnamon.default = [ "xapp" "gtk" ];
  };

  # -- Graphics (base — GPU drivers set per host) -----------------------------
  hardware.graphics.enable = true;

  # -- Bluetooth --------------------------------------------------------------
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
    settings.Policy.AutoEnable = true;
  };

  # -- Audio: PipeWire --------------------------------------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

# -- Printing ---------------------------------------------------------------
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      brlaser           # Support for Brother laser printers
# brother-2390dw-cups-bin # Works for the 3290CDW series
    ];
  };

services.avahi = {
    enable       = true;
    nssmdns4     = true; # This allows you to find "printer.local"
    openFirewall = true;
  };



  # This allows the "Add Printer" dialog to find the Brother binary
  programs.system-config-printer.enable = true;

  # -- VPN --------------------------------------------------------------------
  services.ivpn.enable = true;

  # -- Power (baseline — laptops extend this in their host file) --------------
  powerManagement.enable = true;

  # -- User -------------------------------------------------------------------
  users.users.josh = {
    isNormalUser = true;
    description  = "josh";
    extraGroups  = [ "networkmanager" "wheel" "dialout" "plugdev" ];
  };

services.udev.extraRules = ''


  SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0666", GROUP="dialout", ENV{ID_MM_DEVICE_IGNORE}="1"
  
  ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", ENV{ID_MM_DEVICE_IGNORE}="1"
'';


  # -- Programs ---------------------------------------------------------------
  programs.steam.enable = true;
  programs.nano.enable  = false;

  # -- System Packages --------------------------------------------------------
  # Keep lean — user packages live in home.nix
  environment.systemPackages = with pkgs; [
    git
    neovim
    micro
    kitty
    btop
    bluez
    busybox
    adwaita-icon-theme


  ];
}
