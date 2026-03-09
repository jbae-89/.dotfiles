# hosts/omen-jb/omen-jb.nix
# HP Omen Laptop — Intel CPU + NVIDIA dGPU (PRIME offload), battery/touchpad
{ config, pkgs, ... }:

{
  networking.hostName = "omen-jb";

  # -- Kernel -----------------------------------------------------------------
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # -- NVIDIA PRIME (hybrid offload) ------------------------------------------
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open    = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement = {
      enable      = true;
      finegrained = true;   
    };

    prime = {
      offload = {
        enable           = true;
        enableOffloadCmd = true;   
      };

      intelBusId  = "PCI:00:02:0";   
      nvidiaBusId = "PCI:01:00:0";  
    };
  };

  systemd.services.nvidia-resume.enable    = true;
  systemd.services.nvidia-hibernate.enable = false;

  # -- Battery / Power (TLP) --------------------------------------------------
  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC    = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT   = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC        = "performance";
      PLATFORM_PROFILE_ON_BAT       = "low-power";
    };
  };

  services.upower.enable = true;

  # -- Touchpad ---------------------------------------------------------------
  services.libinput.touchpad = {
    tapping            = true;
    naturalScrolling   = true;
    disableWhileTyping = true;
  };

  # -- Lid / Suspend ----------------------------------------------------------
  services.logind = {
    lidSwitch              = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  system.stateVersion = "25.11";
}
