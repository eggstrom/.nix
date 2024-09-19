{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = with inputs; [ nur.overlay ];
      };
      settings = import ./settings.nix;
      specialArgs = {
        inherit inputs system settings;
      };
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
              extraSpecialArgs = specialArgs;
              users = {
                root = import ./users/root.nix;
                ${settings.username} = import ./users/default.nix;
              };
            };
          }
        ];
      };

      homeConfigurations.${settings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [ ./users/default.nix ];
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
