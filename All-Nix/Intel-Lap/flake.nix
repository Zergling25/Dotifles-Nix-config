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
      user = "zorgon";

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
			inherit user;
			inherit host;
			};
	   		modules = [ 
				./hosts/${host}/config.nix 
				];
			};
		};
	};
}
