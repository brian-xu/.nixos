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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      sops-nix,
      noctalia,
      niri,
      sysc-greet,
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
            { nixpkgs.overlays = (import ./overlays); }
            nixos-hardware.nixosModules.framework-13-7040-amd
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            sysc-greet.nixosModules.default
            ./nixos
            ./hosts/framework-13/configuration.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.sharedModules = [
                niri.homeModules.niri
                noctalia.homeModules.default
              ];
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.brian = import ./homes/brian/default.nix;
            }
          ];
        };
      };
    };
}
