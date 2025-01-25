{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    let
      inherit (builtins)
        attrValues
        listToAttrs
        mapAttrs
        readDir
        ;
      inherit (nixpkgs.lib) attrsets strings;

      systemConfig = import ./config/system.nix;
      userConfigs =
        readDir ./config/users
        |> mapAttrs (
          file: _: {
            name = strings.removeSuffix ".nix" file;
            value = import ./config/users/${file};
          }
        )
        |> attrValues
        |> listToAttrs
        |> attrsets.filterAttrs (username: _: username != "root");

      homeConfigs =
        (userConfigs // { root = { }; })
        |> mapAttrs (
          username: userConfig: {
            home = {
              inherit username;
              homeDirectory = if username == "root" then "/root" else "/home/${username}";
            };
            imports = [
              { inherit userConfig; }
              ./home
              inputs.catppuccin.homeManagerModules.catppuccin
            ];
          }
        );

      system = "x86_64-linux";
      pkgsAttrs = {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs pkgsAttrs;
      pkgs-stable = import nixpkgs-stable pkgsAttrs;

      specialArgs = {
        inherit
          inputs
          system
          pkgs-stable
          systemConfig
          userConfigs
          ;
      };
      extraSpecialArgs = specialArgs;
    in
    {
      nixosConfigurations.${systemConfig.hostname} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hardware-configuration.nix
          ./system
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              inherit extraSpecialArgs;
              users = homeConfigs;
            };
          }
          catppuccin.nixosModules.catppuccin
        ];
      };

      homeConfigurations =
        homeConfigs
        |> mapAttrs (
          _: homeConfig:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs extraSpecialArgs;
            modules = [ homeConfig ];
          }
        );

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
