{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    bat
    curl
    dust
    eza
    fd
    feh
    file
    firefox
    fzf
    gimp
    jq
    mpv
    obs-studio
    prismlauncher
    ripgrep
    steam
    steam-run
    translate-shell
    trash-cli
    unzip
    wget
    wineWowPackages.stable
    yt-dlp
    zip

    # Development
    act
    cmake
    gcc
    gdb
    gnumake
    go
    jdk
    just
    nasm
    nodejs
    python3
    rustup
    sccache
    scrcpy
    valgrind
    zig
  ];

  # ~/.npm/ -> ~/.cache/npm/
  xdg.configFile.npmrc.text = "cache=${config.xdg.cacheHome}/npm";

  services.udiskie = {
    enable = true;
    tray = "never";
  };

  # Generate caches for searching man pages
  programs.man.generateCaches = true;

  # Enable tldr and make it update on execution if needed
  programs.tealdeer = {
    enable = true;
    settings.updates = {
      auto_update = true;
      # Update if cached data is older than a week
      auto_update_interval_hours = 168;
    };
  };

  # Let Home Manager manage mimetypes
  xdg.mimeApps.enable = true;

  # Add ~/.local/bin to $PATH
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
}
