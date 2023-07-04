{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";                     # Default Stable Nix Packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; 
  };
  outputs = { self, nixpkgs, nixpkgs-unstable }@attrs: {
    nixosConfigurations.jk-dell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
