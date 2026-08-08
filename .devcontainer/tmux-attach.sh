#!/usr/bin/env bash

set -euo pipefail

workspace_dir="$PWD"
config_file="$workspace_dir/.devcontainer/tmux.conf"
socket_file="$workspace_dir/.devcontainer/.tmux-shared"

exec tmux -S "$socket_file" -f "$config_file" new-session -A -s soft-factory -c "$workspace_dir"
