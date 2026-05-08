# home.nix — Home Manager config for josh (shared across all hosts)
{ config, pkgs, pkgs-2411, ... }:

{
  home.username = "josh";
  home.homeDirectory = "/home/josh";
  home.stateVersion = "26.05";

  # -- User Packages ----------------------------------------------------------
  home.packages = with pkgs; [

    # -- Internet -------------------------------------------------------------
    brave
    webcord
    firefox

    # -- Productivity ---------------------------------------------------------
    libreoffice
    trilium-desktop
    drawio
    pdf4qt

    # -- Media ----------------------------------------------------------------
    vlc
    spotify

    # -- Development ----------------------------------------------------------
    vscode
    gcc
    arduino-core

    # Rust
    rustc
    cargo

    # Python

    (python313.withPackages (ps: [
      ps.pillow
      ps.numpy
      ps.pyqt5
      ps.pyopengl
      ps.matplotlib
      ps.gradio
      ps.opencv-python
      ps.torch
      ps.torchvision
      # ps.xformers
    ]))

    # Removed for freecad testing but may be needed for QGIS
    # qt5.qtbase
    # qt5.qtwayland
    # libsForQt5.qt5.qtbase


    # Typst
    typst
    tinymist

    # Nix
    nixfmt
    nixd

    # -- Creative / Maker -----------------------------------------------------
    blender

    # freecad

    inkscape-with-extensions
    gimp-with-plugins
    openscad
    
    # -- System Utilities -----------------------------------------------------
    
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

    # # -- Virtualisation -------------------------------------------------------
    # virtualbox
    wine
    winetricks
    # bottles

    # -- Fonts ----------------------------------------------------------------
    source-sans-pro
    source-sans
    roboto
    font-awesome
    corefonts
    freefont_ttf
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    google-fonts

  ];
  # -- Program Alias ------------------------------------------------------------
  xdg.desktopEntries = {
    kitty = {
      name = "Kitty";
      genericName = "Terminal Emulator";
      exec = "kitty";
      icon = "kitty";
      terminal = false;
      categories = [
        "System"
        "TerminalEmulator"
      ];
settings = {
        Keywords = "shell;prompt;command;commandline;cmd;console;";
      };
    };
  };

  # -- Terminal: Kitty --------------------------------------------------------
  programs.kitty = {
    enable = true;
    themeFile = "Brogrammer";

    settings = {
      copy_on_select = "yes";
      confirm_os_window_close = 0;
    };

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";

    };
  };
# -- Bash Aliases -------------------------------------------------------------
programs.bash = {
  enable = true;
  shellAliases = {
    rebuild      = "sudo nixos-rebuild switch --flake .#$(hostname)";
    rebuild-boot = "sudo nixos-rebuild boot --flake .#$(hostname)";
    nix-clean    = "sudo nix-collect-garbage -d";
    ll           = "ls -lah";
    ".."         = "cd ..";
    rayforge = "flatpak run org.rayforge.rayforge";
  };
};


  # -- Git --------------------------------------------------------------------
  programs.git = {
    enable = true;
    settings.init.defaultBranch = "main";
    settings.user.name = "jbae-89";
    settings.user.email = "joshua.e.bailey1@gmail.com";
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