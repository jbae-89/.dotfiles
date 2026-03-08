# hosts/omen-jb/omen-jb.nix
# HP Omen Laptop — Intel CPU + NVIDIA dGPU (PRIME offload), battery/touchpad
{ config, pkgs, ... }:

{
  networking.hostName = "omen-jb";

  # ── Kernel ─────────────────────────────────────────────────────────────────
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # ── NVIDIA PRIME (hybrid offload) ──────────────────────────────────────────
  # Display renders on Intel iGPU by default; apps can be launched on the
  # NVIDIA dGPU on demand with: nvidia-offload <app>
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open    = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement = {
      enable      = true;
      finegrained = true;   # Power-gate dGPU when idle
    };

    prime = {
      offload = {
        enable           = true;
        enableOffloadCmd = true;   # Adds `nvidia-offload` helper to PATH
      };

      # ⚠️  Update these Bus IDs to match YOUR Omen's hardware.
      # Run on the machine:
      #   nix-shell -p pciutils --run "lspci | grep -E 'VGA|3D'"
      # Format: PCI:<bus>:<device>:<function>
      intelBusId  = "PCI:00:02:0";   # Intel iGPU  — verify on device
      nvidiaBusId = "PCI:01:00:0";   # NVIDIA dGPU — verify on device
    };
  };

  systemd.services.nvidia-resume.enable    = true;
  systemd.services.nvidia-hibernate.enable = false;

  # ── Battery / Power (TLP) ──────────────────────────────────────────────────
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

  # ── Touchpad ───────────────────────────────────────────────────────────────
  services.libinput.touchpad = {
    tapping            = true;
    naturalScrolling   = true;
    disableWhileTyping = true;
  };

  # ── Lid / Suspend ──────────────────────────────────────────────────────────
  services.logind = {
    lidSwitch              = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  system.stateVersion = "25.11";
}
