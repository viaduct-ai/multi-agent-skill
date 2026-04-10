#!/usr/bin/env bash
# _lib.sh — shared helpers for multi-agent tmux orchestration
# Source this file from the individual scripts.

_WORKER_NAMES=(Wade Wesley Winston Wyatt Warren Walter Wilson Wolf Willis Wendell)

# Set @worker-name user option on a pane (survives visual title overrides)
_ma_set_worker_name() {
  local pane="$1" name="$2"
  tmux set-option -p -t "$pane" @worker-name "$name"
}

# Read @worker-name from a pane; prints nothing if unset
_ma_get_worker_name() {
  local pane="$1"
  tmux show-options -p -t "$pane" -v @worker-name 2>/dev/null
}

# Set @worker-task user option on a pane
_ma_set_worker_task() {
  local pane="$1" description="$2"
  tmux set-option -p -t "$pane" @worker-task "$description"
}

# Read @worker-task from a pane; prints nothing if unset
_ma_get_worker_task() {
  local pane="$1"
  tmux show-options -p -t "$pane" -v @worker-task 2>/dev/null
}

# Find a pane in the current window by its @worker-name; prints pane_id or nothing
_ma_get_pane_id_by_worker_name() {
  local target="$1"
  while IFS= read -r pane_id; do
    local name
    name=$(_ma_get_worker_name "$pane_id")
    if [[ "$name" == "$target" ]]; then
      echo "$pane_id"
      return
    fi
  done < <(tmux list-panes -F '#{pane_id}')
}

# Find Simon's pane by @worker-name option in the current window
_ma_get_sage_pane() {
  _ma_get_pane_id_by_worker_name "Simon"
}

# List all panes in the current window that have @worker-name set
# Prints: pane_id worker_name
_ma_list_worker_panes() {
  while IFS= read -r pane_id; do
    local name
    name=$(_ma_get_worker_name "$pane_id") || true
    if [[ -n "$name" ]]; then
      echo "$pane_id $name"
    fi
  done < <(tmux list-panes -F '#{pane_id}')
}

# Collect names already in use (via @worker-name) in the current window
_ma_used_worker_names() {
  _ma_list_worker_panes | awk '{ print $2 }'
}
