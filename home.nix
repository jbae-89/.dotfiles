# home.nix — Home Manager config for josh (shared across all hosts)
{ config, pkgs, ... }:

{
  home.username    = "josh";
  home.homeDirectory = "/home/josh";
  home.stateVersion  = "25.11";

  # -- User Packages ----------------------------------------------------------
  home.packages = with pkgs; [

    # -- Internet -------------------------------------------------------------
    brave
    webcord

    # -- Productivity ---------------------------------------------------------
    libreoffice
    trilium-desktop
    drawio

    # -- Media ----------------------------------------------------------------
    vlc

    # -- Development ----------------------------------------------------------
    vscode
    gcc

    # Rust
    rustc
    cargo
    # clippy
    # rustfmt

    # Python
    python313
    python313Packages.rasterio

    # Typst
    typst
    tinymist

    # Nix
    nixfmt-rfc-style   # nixfmt was renamed; this is the current package
    nixd

    # -- GIS ------------------------------------------------------------------
    (qgis.override {
      extraPythonPackages = ps: with ps; [
        matplotlib
        numpy
        rasterio
      ];
    })

    # -- Creative / Maker -----------------------------------------------------
    blender
    freecad
    inkscape-with-extensions
    gimp-with-plugins
    bambu-studio

    # -- System Utilities -----------------------------------------------------
    btop
    htop
    fzf
    syncthing

    # -- Networking / VPN -----------------------------------------------------
    ivpn
    ivpn-ui

    # -- Torrenting -----------------------------------------------------------
    deluge-gtk

    # -- Virtualisation -------------------------------------------------------
    virtualbox

    # -- Fonts ----------------------------------------------------------------
    source-sans-pro
    source-sans
    roboto
    font-awesome

  ];

  # -- Shell: Bash ------------------------------------------------------------
  programs.bash = {
    enable = true;
    shellAliases = {
      # Rebuild this machine — run from inside your dotfiles directory
      rebuild      = "sudo nixos-rebuild switch --flake .#$(hostname)";
      rebuild-boot = "sudo nixos-rebuild boot --flake .#$(hostname)";
      nix-clean    = "sudo nix-collect-garbage -d";
      cmd          = "kitty";

      # Shortcuts
      ll   = "ls -lah";
      ".." = "cd ..";
    };
  };


  # -- Git --------------------------------------------------------------------
    programs.git = {
    enable    = true;
    extraConfig.init.defaultBranch = "main";
  };

  # -- Syncthing -------------------------------------------------------------
  services.syncthing.enable = true;

  # -- Session Variables ------------------------------------------------------
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # -- Home Manager self-management ------------------------------------------
  programs.home-manager.enable = true;
}
