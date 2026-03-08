{
  description = "Primary_Flake";

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
          # Shared config for all machines
          ./common.nix

          # Per-host system config (hostname, GPU, power, etc.)
          ./hosts/${hostname}/${hostname}.nix

          # Per-host hardware config (generated via nixos-generate-config)
          ./hosts/${hostname}/hardware-configuration.nix

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.users.josh       = import ./home.nix;
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
