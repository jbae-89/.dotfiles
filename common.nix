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

  environment.cinnamon.excludePackages = with pkgs; [ gnome-terminal ];

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
  services.printing.enable = true;
  services.avahi = {
    enable       = true;
    nssmdns4     = true;
    openFirewall = true;
  };

  # -- VPN --------------------------------------------------------------------
  services.ivpn.enable = true;

  # -- Power (baseline — laptops extend this in their host file) --------------
  powerManagement.enable = true;

  # -- User -------------------------------------------------------------------
  users.users.josh = {
    isNormalUser = true;
    description  = "josh";
    extraGroups  = [ "networkmanager" "wheel" ];
  };

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
  ];
}
