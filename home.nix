{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "josh";
  home.homeDirectory = "/home/josh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # Allow unfree Moved to configuration.nix
  #  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    # Install these with home manager

    # Wallpaper Manager
    hydrapaper
    # Internet
    webcord

    # Programming (Multi-Lang)
    vscode
    gcc

    # Rust
    rustc
    cargo
    #	clippy
    #	rustfmt

    # Python
    python313
    python313Packages.rasterio
    # Typst
    typst
    tinymist
 
    # Nix
    nixfmt
    nixd

    # Productivity
    libreoffice
    trilium-desktop
    drawio

    # Maker - Applications
    blender
    freecad
    inkscape-with-extensions
    gimp-with-plugins
    
(qgis.override {
    extraPythonPackages = ps: with ps; [
      matplotlib
      numpy
      rasterio
      # srtm.py is 'srtm' in nixpkgs
    ];
  })

   # qgis
 #bambu-studio

    # Media
    vlc

    # System
    btop
    syncthing
    htop
    bluez
    fzf

    # Misc
    ivpn-ui
    ivpn

# Torrenting
    deluge-gtk

 # Game Related
    steam
    
# Testing
    virtualbox
    #linuxKernel.packages.linux_zen.virtualbox
    #linuxKernel.packages.linux_xanmod_stable.virtualbox

  # Fonts
  source-sans-pro
  source-sans
  roboto
  font-awesome

  ];

# fonts = {
#   enableDefaultPackages = true;
#   packages = with pkgs; [
#     noto-fonts
#     fira-code
#     (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
#   ];
# };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/josh/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Enable starship

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

       character = {
         success_symbol = "[➜](bold green)";
         error_symbol = "[➜](bold red)";
       };

      # package.disabled = true;
    };
  };


}
