{
  description = "NixOS-Config"; 
  	
  inputs = {
  	nixpkgs.url = "nixpkgs/nixos-unstable";
  	};

  outputs = 
	inputs@{ self, nixpkgs, ... }:
    	let
      system = "x86_64-linux";
      host = "Intel-Lap-NixOS";
      username = "Zorgon";

    pkgs = import nixpkgs {
       	inherit system;
       	config = {
       	allowUnfree = true;
       	};
      };
    in
      {
	nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem rec {
		specialArgs = { 
			inherit system;
			inherit inputs;
			inherit username;
			inherit host;
			};
	   		modules = [ 
				./hosts/${host}/config.nix 
				];
			};
		};
	};
}
