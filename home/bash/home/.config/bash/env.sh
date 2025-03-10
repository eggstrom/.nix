#!/usr/bin/env bash

# Source Home Manager session variables
if [[ -r ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]]; then
  . ~/.nix-profile/etc/profile.d/hm-session-vars.sh
elif [[ -r ~/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh ]]; then
  . ~/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh
fi

. ~/.config/bash/xdg.sh

# Default programs
export EDITOR=hx
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export TERMINAL=kitty

# Colors
eval "$(dircolors)"
export BAT_THEME=base16-256

# Cache Rust builds globally
export RUSTC_WRAPPER=sccache

# Add paths to $PATH if they're not already present
add_path() {
  if [[ ":$PATH:" != *":$1:"* ]]; then PATH="${PATH:+$PATH:}$1"; fi
}
add_path ~/.local/bin
add_path "$CARGO_HOME/bin"
add_path "$GOPATH/bin"
unset -f add_path
