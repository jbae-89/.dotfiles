{

description = "Default_Flake";

inputs = {

#	nixpkgs = {
#	url = "github:/NixOS/nixpkgs/nixos-25.11";
#	};

	nixpkgs.url = "github:/NixOS/nixpkgs/nixos-25.11";

#	nixpkgs.url = "nixpkgs/nixos-25.11";


home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # This line ensures home-manager uses the same nixpkgs version as your system
      inputs.nixpkgs.follows = "nixpkgs";
    };

};



outputs = {self, nixpkgs, home-manager, ...}:

	let 
		lib = nixpkgs.lib;
	in { 

	nixosConfigurations = {	
	nixos = lib.nixosSystem {
		
		system = "x86_64-linux";
		modules = [
					
					#./configuration.nix

					# Import the Home Manager NixOS module
					      home-manager.nixosModules.home-manager
					      {
					        home-manager.useGlobalPkgs = true;
					        home-manager.useUserPackages = true;
					        home-manager.users.josh = import ./home.nix; # Point to your home.nix
					      }

					
				  ];		
		
		};

	};

};	

}
