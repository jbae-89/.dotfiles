# hosts/leno-jb/leno-jb.nix
# Lenovo Laptop — Intel CPU, integrated graphics only, battery/touchpad
{ config, pkgs, ... }:

{
  networking.hostName = "leno-jb";

  # -- Kernel -----------------------------------------------------------------
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # -- Integrated Graphics (Intel) --------------------------------------------
  # hardware.graphics is enabled in common.nix.
  # Intel media driver for hardware video acceleration:
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver   # VA-API (Broadwell+)
    intel-vaapi-driver   # VA-API (older gen fallback)
    #vaapiVdpau
    libva-vdpau-driver    
    libvdpau-va-gl
  ];

  # -- Battery / Power (TLP) --------------------------------------------------
  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC  = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC  = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      # Lenovo charge thresholds — extend battery lifespan
      START_CHARGE_THRESH_BAT0 = 20;
      STOP_CHARGE_THRESH_BAT0  = 80;
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
