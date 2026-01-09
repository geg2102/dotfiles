#!/bin/bash
# Activate Python virtual environment based on tmux session/pane context or current directory

# determine if the tmux server is running
if tmux list-sessions &>/dev/null; then
	TMUX_RUNNING=0
else
	TMUX_RUNNING=1
fi

# determine the user's current position relative tmux:
# serverless - there is no running tmux server
# attached   - the user is currently attached to the running tmux server
# detached   - the user is currently not attached to the running tmux server
T_RUNTYPE="serverless"
if [ "$TMUX_RUNNING" -eq 0 ]; then
	if [ "$TMUX" ]; then # inside tmux
		T_RUNTYPE="attached"
	else # outside tmux
		T_RUNTYPE="detached"
	fi
fi

# Activate virtual environment if it exists in current directory
activate_venv() {
    if [ -d ".venv" ] && [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
        return 0
    fi
    return 1
}

# Try to find and activate venv based on session/pane name as directory
activate_by_name() {
    local NAME=$1
    local SEARCH_PATHS=("$HOME/projects" "$HOME/work" "$HOME")

    for base_path in "${SEARCH_PATHS[@]}"; do
        local target_dir="$base_path/$NAME"
        if [ -d "$target_dir/.venv" ] && [ -f "$target_dir/.venv/bin/activate" ]; then
            source "$target_dir/.venv/bin/activate"
            return 0
        fi
    done
    return 1
}

case $T_RUNTYPE in
    attached)
        SESSION_NAME=$(tmux display-message -p '#{session_name}')
        PANE_NAME="$(tmux display-message -p '#{pane_title}')"

        # First try current directory
        if activate_venv; then
            :
        # Then try session name as project directory
        elif activate_by_name "$SESSION_NAME"; then
            :
        # Then try pane name as project directory
        elif activate_by_name "$PANE_NAME"; then
            :
        fi
        ;;
    *)
        # Outside tmux, just try to activate local .venv
        activate_venv
        ;;
esac