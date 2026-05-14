{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      sops-nix,
      plasma-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (_: _: import ./lib { lib = nixpkgs.lib; });
    in
    {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            lib = lib.extend (_: _: inputs.home-manager.lib);
          };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./nixos
            ./hosts/framework-13/configuration.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
              ];
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.brian = import ./homes/brian/default.nix;
            }
          ];
        };
      };
    };
}
