{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    subtui.url = "github:MattiaPun/SubTUI";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      sops-nix,
      niri,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (_: _: import ./lib { inherit (nixpkgs) lib; });
    in
    {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            lib = lib.extend (_: _: inputs.home-manager.lib);
          };
          modules = [
            { nixpkgs.overlays = import ./overlays { inherit inputs; }; }
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
                niri.homeModules.niri
              ];
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.brian = import ./homes/brian/default.nix;
            }
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
