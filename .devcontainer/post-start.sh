#!/usr/bin/env bash

set -euo pipefail

workspace_dir="$PWD"
config_file="$workspace_dir/.devcontainer/tmux.conf"
socket_file="$workspace_dir/.devcontainer/.tmux-shared"

if ! tmux -S "$socket_file" has-session -t soft-factory 2>/dev/null; then
    tmux -S "$socket_file" -f "$config_file" new-session -d -s soft-factory -c "$workspace_dir"
fi

tmux -S "$socket_file" source-file "$config_file"

if [[ -n "${BROWSER:-}" ]]; then
    tmux -S "$socket_file" set-environment -g BROWSER "$BROWSER"
fi

if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    tmux -S "$socket_file" set-environment -g WAYLAND_DISPLAY "$WAYLAND_DISPLAY"
fi

if [[ -n "${XDG_RUNTIME_DIR:-}" ]]; then
    tmux -S "$socket_file" set-environment -g XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR"
fi
