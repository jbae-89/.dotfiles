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

  # -- Desktop: KDE Plasma + SDDM ---------------------------------------------
  services.xserver = {
    enable = true;
    xkb = { layout = "us"; variant = ""; };
    excludePackages = with pkgs; [ xterm ];
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; 
  };

  services.desktopManager.plasma6.enable = true;

  services.displayManager.defaultSession = "plasma";

  services.libinput.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole 
    oxygen 
  ];

  # -- Environment ------------------------------------------------------------
  environment.variables = {
    XCURSOR_SIZE  = "24";
    XCURSOR_THEME = "breeze_cursors";
    GDAL_DRIVER_PATH = "/run/current-system/sw/lib/gdalplugins";
  };

  # -- D-Bus ------------------------------------------------------------------
  services.dbus.enable = true;

  # -- Qt / GTK theming -------------------------------------------------------
  qt = {
    enable        = true;
    platformTheme = "kde";
    style         = "breeze";
  };

  # -- XDG portals ------------------------------------------------------------
xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  config.common.default = "kde";
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
    enable  = true;
    browsing = false;
    drivers = with pkgs; [
      brlaser
    ];
  };

  services.avahi = {
    enable       = true;
    nssmdns4     = true;
    openFirewall = true;
  };

  programs.system-config-printer.enable = true;

  # -- VPN --------------------------------------------------------------------
  services.ivpn.enable = true;

  # -- Power (baseline — laptops extend this in their host file) --------------
  powerManagement.enable = true;

  # -- User -------------------------------------------------------------------
  users.users.josh = {
    isNormalUser = true;
    description  = "josh";
    extraGroups  = [ "networkmanager" "wheel" "dialout" "plugdev" "vboxusers"];
  };


  # -- Virtualization ---------------------------------------------------------
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0666", GROUP="dialout", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", ENV{ID_MM_DEVICE_IGNORE}="1"
  '';

  # -- Programs ---------------------------------------------------------------
  programs.steam.enable = true;
  programs.nano.enable  = false;

  # -- System Packages --------------------------------------------------------
  environment.systemPackages = with pkgs; [
    git
    neovim
    micro
    kitty
    btop
    bluez
    busybox
  ];
}