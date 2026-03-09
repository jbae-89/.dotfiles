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
# -- Program Alias ------------------------------------------------------------
xdg.desktopEntries = {
    kitty = {
      name = "Kitty";
      genericName = "Terminal Emulator";
      exec = "kitty";
      icon = "kitty";
      terminal = false;
      categories = [ "System" "TerminalEmulator" ];
      settings = {
        # This adds "cmd" and "console" to the search index
        Keywords = "shell;prompt;command;commandline;cmd;console;";
      };
    };
  };

# -- Neovim settings ----------------------------------------------------------
programs.neovim = {
  enable = true;
  extraConfig = ''
    set number
    set relativenumber
  '';
  plugins = with pkgs.vimPlugins; [
    vim-nix
    (nvim-treesitter.withPlugins (plugins: with plugins; [
    	nix
    	python
    	rust
    	c
    	go
    	
    ]
    ))
  ];
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



  # -- Shell: Bash ------------------------------------------------------------
  programs.bash = {
    enable = true;
    shellAliases = {
      # Rebuild this machine — run from inside your dotfiles directory
      rebuild      = "sudo nixos-rebuild switch --flake .#$(hostname)";
      rebuild-boot = "sudo nixos-rebuild boot --flake .#$(hostname)";
      nix-clean    = "sudo nix-collect-garbage -d";

      # Shortcuts
      ll   = "ls -lah";
      ".." = "cd ..";
    };
  };


  # -- Git --------------------------------------------------------------------
    programs.git = {
    enable    = true;
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
