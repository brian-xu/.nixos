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
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (_: _: import ./lib { inherit (nixpkgs) lib; });

      specialArgs = {
        inherit inputs;
        lib = lib.extend (_: _: inputs.home-manager.lib);
      };

      frameworkModules = [
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
    in
    {
      nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = frameworkModules;
      };

      checks.x86_64-linux.boot = nixpkgs.legacyPackages.x86_64-linux.testers.runNixOSTest {
        name = "framework-boot";
        node.specialArgs = specialArgs;
        node.pkgsReadOnly = false;
        requiredFeatures.kvm = false;
        nodes.machine = {
          imports = frameworkModules;
          virtualisation.cores = 4;
          virtualisation.memorySize = 4096;
          virtualisation.useBootLoader = true;
          virtualisation.useEFIBoot = true;
        };
        testScript = ''
          machine.start()
          machine.wait_for_console_text("Reached target Multi-User System", timeout=1800)
          machine.wait_for_unit("multi-user.target")
        '';
      };

      checks.x86_64-linux.boot-luks =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          disko-config = nixpkgs.lib.recursiveUpdate (import ./hosts/framework-13/disko.nix) {
            disko.devices.disk.nvme0n1.content.partitions.luks.content.settings.keyFile = "/tmp/secret.key";
            disko.devices.disk.nvme0n1.content.partitions.swap.size = "1G";
          };
        in
        inputs.disko.lib.testLib.makeDiskoTest {
          inherit pkgs disko-config;
          name = "framework-boot-luks";
          efi = true;
          testBoot = true;
          bootCommands = ''
            machine.wait_for_console_text("Reached target Local File Systems", timeout=1800)
          '';
          extraTestScript = ''
            machine.wait_for_unit("multi-user.target")
          '';
        };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
