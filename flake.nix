{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    {
      nixpkgs,
      nur,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nur.overlay ];
      };
      settings = import ./settings.nix;
      specialArgs = {
        inherit inputs system settings;
      };
      extraSpecialArgs = specialArgs;
    in
    {
      nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hardware-configuration.nix
          ./nixos
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              inherit extraSpecialArgs;
              users = {
                root = import ./users/root.nix;
                ${settings.username} = import ./users/default.nix;
              };
            };
          }
          catppuccin.nixosModules.catppuccin
        ];
      };

      homeConfigurations = {
        root = home-manager.lib.homeManagerConfiguration {
          inherit pkgs extraSpecialArgs;
          modules = [ ./users/root.nix ];
        };

        ${settings.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs extraSpecialArgs;
          modules = [ ./users/default.nix ];
        };
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
