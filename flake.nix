{
  description = "Primary_Flake";

  # nixConfig = {

  # };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
              (nixpkgs.legacyPackages.x86_64-linux.qgis.override {
                extraPythonPackages = ps: [ ps.scipy ps.matplotlib ];
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