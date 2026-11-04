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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    subtui.url = "github:MattiaPun/SubTUI";
    latchshot.url = "github:so1ve/latchshot";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      sops-nix,
      disko,
      niri,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (_: _: import ./lib { inherit (nixpkgs) lib; });
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      csharpier = pkgs.writeShellApplication {
        name = "csharpier";
        runtimeInputs = [
          pkgs.dotnet-sdk
          pkgs.csharpier
        ];
        text = ''
          csharpier "$@"
        '';
      };
      treefmt =
        (treefmt-nix.lib.evalModule pkgs {
          projectRootFile = ".git/config";
          programs.nixfmt.enable = true;
          programs.csharpier = {
            enable = true;
            package = csharpier;
          };
        }).config.build.wrapper;
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
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ./nixos
            ./hosts/framework-13/configuration.nix
            ./hosts/framework-13/desktop.nix
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

      formatter.x86_64-linux = treefmt;

      packages.x86_64-linux = {
        inherit treefmt csharpier;
      };
    };
}
