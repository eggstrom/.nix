{ inputs, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  home.packages = with pkgs; [ nix-search-cli ];

  nix = {
    # Make registry use this flake's version of nixpkgs
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      # Optimise store on every build
      auto-optimise-store = true;
      # .nix-{defexpr,profile} -> .local/state/nix/{defexpr,profile}
      use-xdg-base-directories = true;
    };

    gc = {
      # Run garbage collector weekly
      automatic = true;
      # Delete generations older than 7 days
      options = "--delete-older-than 7d";
    };
  };
}
