{
  description = "Primary_Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-2411,
      home-manager,
      nixvim,
      ...
    }:
    let
      lib = nixpkgs.lib;

      mkHost = hostname: lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./hosts/${hostname}/${hostname}.nix
          ./hosts/${hostname}/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { pkgs-2411 = nixpkgs-2411.legacyPackages.x86_64-linux; };
            home-manager.users.josh = {
              imports = [
                nixvim.homeModules.nixvim
                (import ./home.nix)
              ];
            };
          }

          {
            environment.systemPackages = [
              # --- 1. QGIS Wrapper (X11 Fix) ---
              (let
                pkgs-x86 = nixpkgs.legacyPackages.x86_64-linux;
                myQgis = (pkgs-x86.qgis.override {
                  extraPythonPackages = ps: [
                    ps.matplotlib
                    ps.rasterio
                    ps.numpy
                  ];
                });
              in
              pkgs-x86.symlinkJoin {
                name = "qgis-x11";
                paths = [ myQgis ];
                nativeBuildInputs = [ pkgs-x86.makeWrapper ];
                postBuild = ''
                  wrapProgram $out/bin/qgis \
                    --set QT_QPA_PLATFORM xcb
                '';
              })

              # --- 2. FreeCAD Wrapper (NVIDIA/CAM Fix) ---
              (let
                pkgs-x86 = nixpkgs.legacyPackages.x86_64-linux;
              in
              pkgs-x86.symlinkJoin {
                name = "freecad-fixed";
                paths = [ pkgs-x86.freecad ];
                nativeBuildInputs = [ pkgs-x86.makeWrapper ];
                postBuild = ''
                  wrapProgram $out/bin/FreeCAD \
                    --set __GLX_VENDOR_LIBRARY_NAME nvidia \
                    --set QT_XCB_GL_INTEGRATION xcb_glx \
                    --set QT_QPA_PLATFORM xcb
                '';
              })
            ];
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        desk-jb = mkHost "desk-jb";
        leno-jb = mkHost "leno-jb";
        omen-jb = mkHost "omen-jb";
      };
    };
}