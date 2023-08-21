{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                     # Default Stable Nix Packages
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager }@inputs: {
    nixosConfigurations.laptop-dell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
