{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.05";
  };

  outputs = { self, nixpkgs }@inputs: {
	nixosConfigurations.home-jellyfin = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			./configuration.nix
		];

 	};
  };
}
