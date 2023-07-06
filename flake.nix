{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";                     # Default Stable Nix Packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }@inputs: {
    nixosConfigurations.laptop-dell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
