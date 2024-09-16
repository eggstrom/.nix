{ pkgs, ... }:
{
  home.packages = with pkgs; [
    i3
    i3lock-color
    maim
    picom
    xclip
    xdotool
  ];

  xdg.configFile = {
    i3 = {
      source = ./home/.config/i3;
      recursive = true;
    };
    picom = {
      source = ./home/.config/picom;
      recursive = true;
    };
    xinitrc.source = ./home/.config/xinitrc;
  };
}