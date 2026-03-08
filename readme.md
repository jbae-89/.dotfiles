# .dotfiles

Josh's NixOS configuration — Nix Flakes + Home Manager, three machines.

## Structure

```
.dotfiles/
├── flake.nix                        # Entry point — wires all hosts together
├── common.nix                       # Shared config (DE, audio, printing, VPN…)
├── home.nix                         # Home Manager — user packages, shell, git
└── hosts/
    ├── desk-jb/
    │   ├── desk-jb.nix              # Desktop: AMD CPU, NVIDIA GPU
    │   └── hardware-configuration.nix
    ├── leno-jb/
    │   ├── leno-jb.nix              # Lenovo laptop: Intel CPU, iGPU, TLP
    │   └── hardware-configuration.nix
    └── omen-jb/
        ├── omen-jb.nix              # HP Omen laptop: Intel CPU, NVIDIA PRIME
        └── hardware-configuration.nix
```

## First-time setup on a new machine

```bash
# 1. Clone
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Generate hardware config for THIS machine (if not already committed)
nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix

# 3. Build and switch
sudo nixos-rebuild switch --flake .#$(hostname)
```

## Day-to-day rebuilds

The `rebuild` alias (set in home.nix) auto-detects the hostname:

```bash
cd ~/.dotfiles
rebuild          # nixos-rebuild switch --flake .#<hostname>
rebuild-boot     # takes effect on next boot
nix-clean        # garbage-collect old generations
```

## Adding a new host

1. Create `hosts/<hostname>/` with `<hostname>.nix` and a hardware config placeholder
2. Add `<hostname> = mkHost "<hostname>";` to `flake.nix`
3. On the machine, run `nixos-generate-config` and commit the result

## omen-jb: NVIDIA PRIME Bus IDs

You **must** set the correct PCI bus IDs in `hosts/omen-jb/omen-jb.nix`
before building on that machine:

```bash
nix-shell -p pciutils --run "lspci | grep -E 'VGA|3D'"
```

Update `intelBusId` and `nvidiaBusId` in `omen-jb.nix` to match.

## Todo
- Confirm omen-jb PRIME bus IDs
- Add git email to home.nix
- Consider per-host home-manager overrides if package lists diverge
