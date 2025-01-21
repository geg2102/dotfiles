#!/bin/bash
# List python environments
CONDA_ENVS=()
while IFS= read -r line; do
    CONDA_ENVS+=("$line")
done < <(conda env list | grep -E '^[^#]' | awk '{print $1}')


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

revert_to_base() {
    conda activate base
}

act() {
    conda activate $1
    # poetry config virtualenvs.path $(which python | sed 's|/bin/python||')
}

check_name_against_envs() {
    local NAME_TO_CHECK=$1
    for env in "${CONDA_ENVS[@]}"; do
        if [ "$NAME_TO_CHECK" = "$env" ]; then
            return 0
        fi
    done
    return 1
}

case $T_RUNTYPE in 
    attached)
        SESSION_NAME=$(tmux display-message -p '#{session_name}')
        PANE_NAME="$(tmux display-message -p '#{pane_title}')"

        if check_name_against_envs "$SESSION_NAME"; then
            act "$SESSION_NAME"
        elif check_name_against_envs "$PANE_NAME"; then
            act "$PANE_NAME"
        else
            revert_to_base
        fi
        ;;
esac
