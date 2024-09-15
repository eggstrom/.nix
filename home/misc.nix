{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      bat
      bottom
      curl
      discord
      dust
      eza
      fd
      feh
      firefox
      fzf
      gcc
      gimp
      git
      go
      jq
      manix
      mpv
      prismlauncher
      pulsemixer
      ripgrep
      steam
      tealdeer
      trash-cli
      udiskie
      unzip
      wget
      yazi
      zip

      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      font-awesome
      catppuccin-cursors.mochaDark
      (catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "red" ];
      })
    ];
  };
}
