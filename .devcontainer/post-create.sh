#!/usr/bin/env bash

set -euo pipefail

workspace_dir="$PWD"
config_dir="$HOME/.config/tmux"
config_file="$workspace_dir/.devcontainer/tmux.conf"

mkdir -p "$config_dir"
ln -sfn "$config_file" "$config_dir/tmux.conf"

gh alias set --clobber --shell login \
    'eval "$(tmux show-environment -g -s BROWSER 2>/dev/null || true)"; eval "$(tmux show-environment -g -s WAYLAND_DISPLAY 2>/dev/null || true)"; eval "$(tmux show-environment -g -s XDG_RUNTIME_DIR 2>/dev/null || true)"; gh auth login --web --clipboard'
