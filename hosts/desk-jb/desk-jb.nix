# hosts/desk-jb/desk-jb.nix
# Desktop — AMD CPU, NVIDIA GPU (discrete only, no hybrid)
{ config, pkgs, ... }:

{
  networking.hostName = "desk-jb";

  # -- Kernel -----------------------------------------------------------------
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "mem_sleep_default=deep"
  ];


  boot.resumeDevice = "/dev/disk/by-uuid/92fa38af-7c84-4d2a-9075-c6207912e1f4";


  boot.initrd.systemd.enable = true;

  # -- NVIDIA -----------------------------------------------------------------
  
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open    = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.finegrained = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

hardware.graphics = {
  enable = true;
  enable32Bit = true;

  extraPackages = with pkgs; [
    nvidia-vaapi-driver
  # Sim issue in FreeCAD
    # pkgs.mesa
  ];
};


  # -- Host-specific packages -------------------------------------------------
  environment.systemPackages = with pkgs; [
  vulkan-loader
  vulkan-tools
  vulkan-validation-layers
  egl-wayland
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
