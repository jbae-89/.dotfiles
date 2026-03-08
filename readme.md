# .dotfiles

## Structure

```
.dotfiles/
├── flake.nix                        # Entry point
├── common.nix                       # Shared config (DE, audio, printing, VPN…)
├── home.nix                         # Home Manager — user packages, shell, git
└── hosts/
    ├── desk-jb/
    │   ├── desk-jb.nix              # Desktop: AMD CPU, NVIDIA GPU
    │   └── hardware-configuration.nix
    ├── leno-jb/
    │   ├── leno-jb.nix              # Lenovo Thinkpad laptop: Intel CPU, iGPU, TLP
    │   └── hardware-configuration.nix
    └── omen-jb/
        ├── omen-jb.nix              # HP Omen laptop: Intel CPU, NVIDIA PRIME
        └── hardware-configuration.nix
```
```
NOTE: TLP disabled due to conflict
NOTE: common.nix should have all baseline programs, exclusions in individual host.nix
```

