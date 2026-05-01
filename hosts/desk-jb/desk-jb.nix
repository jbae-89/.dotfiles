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
    "mem_sleep_default=deep"
  ];

  boot.initrd.systemd.enable = true;

  # -- NVIDIA -----------------------------------------------------------------
  
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open    = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.finegrained = false;
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];



  # -- Host-specific packages -------------------------------------------------
  environment.systemPackages = with pkgs; [
  vulkan-loader
  vulkan-tools
  vulkan-validation-layers
  ];

networking.firewall = {
  enable = true;
  # Ports for Bambu Studio printer discovery
  allowedUDPPorts = [ 1900 5353 ]; 
  allowedTCPPorts = [ 8080 ]; # Optional: for some local camera streams
  
  # Advanced: If simple port opening isn't enough for multicast discovery
  extraCommands = ''
    iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
  '';
};



  system.stateVersion = "26.05";
}
