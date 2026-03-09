# hosts/desk-jb/desk-jb.nix
# Desktop — AMD CPU, NVIDIA GPU (discrete only, no hybrid)
{ config, pkgs, ... }:

{
  networking.hostName = "desk-jb";

  # -- Kernel -----------------------------------------------------------------
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  boot.initrd.systemd.enable = true;

  # -- NVIDIA -----------------------------------------------------------------
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open    = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
  };

  systemd.services.nvidia-suspend.enable   = true;
  systemd.services.nvidia-resume.enable    = true;
  systemd.services.nvidia-hibernate.enable = true;

  # -- Host-specific packages -------------------------------------------------
  environment.systemPackages = with pkgs; [
    bambu-studio
    vlc
    # Uncomment to open LAN ports for Bambu Studio:
    # (handled via networking.firewall.extraCommands if needed)
  ];

  system.stateVersion = "25.11";
}
