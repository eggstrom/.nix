{
  pkgs,
  settings,
  ...
}:
{
  # Enable Git
  programs.git = {
    enable = true;
    userName = "${settings.git.username}";
    userEmail = "${settings.git.email}";
    extraConfig.credential = {
      # Use main account for credentials by default
      username = "${settings.git.username}";
      helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      # Use pass for storing credentials
      credentialStore = "gpg";
      guiPrompt = false;
    };
  };

  # Create script for conveniently setting username and email
  home.packages = with pkgs; [
    (writeShellScriptBin "git-user" ''
      set -e
      git rev-parse --is-inside-work-tree >/dev/null

      # Unset username and email if no parameters are given
      if [[ -z "$1" && -z "$2" ]]; then
        git config --unset user.name || true
        git config --unset user.email || true
        git config --unset credential.username || true
        exit 0
      fi

      # Set username and email if two parameters are given
      [[ -n "$1" && -n "$2" ]]
      git config user.name "$1"
      git config user.email "$2"
      git config credential.username "$1"
    '')
  ];

  # Enable GitHub CLI
  programs.gh.enable = true;

  # Enable TUI for Git
  programs.lazygit = {
    enable = true;
    settings.gui.border = "single";
  };
  catppuccin.lazygit.enable = true;
}
