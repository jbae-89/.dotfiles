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
    open    = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.finegrained = false;
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  #systemd.services.nvidia-suspend.enable   = true;
  #systemd.services.nvidia-resume.enable    = true;
  #systemd.services.nvidia-hibernate.enable = true;

boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];



  # -- Host-specific packages -------------------------------------------------
  environment.systemPackages = with pkgs; [
    #bambu-studio
    #orca-slicer
    # Uncomment to open LAN ports for Bambu Studio:
    # (handled via networking.firewall.extraCommands if needed)
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



  system.stateVersion = "25.11";
}
