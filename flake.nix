{
  description = "Primary_Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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
            home-manager.users.josh      = import ./home.nix;
          }

          {
environment.systemPackages = [
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