{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.05";
    comin = {
      url = "github:nlweo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, comin, ... }@inputs: {
	nixosConfigurations.home-jellyfin = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
      comin.nixosModules.comin
          ({...}: {
            services.comin = {
              enable = true;
              remotes = [{
                name = "origin";
                url = "https://github.com/grendel71/home-nix-infra.git";
                branches.main.name = "main";
              }];
            };
          })
			./configuration.nix
		];

 	};
  };
}
