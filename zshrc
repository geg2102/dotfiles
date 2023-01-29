# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -z "$TMUX" ]; then 
    export TERM=xterm-256color
else 
    export TERM=screen-256color
fi

# Path to oh-my-zsh installation.
export ZSH="$HOME/dotfiles/oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"

## Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(z git common-aliases brew zsh-autosuggestions vi-mode)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

alias vim='nvim'
alias tmux='tmux -2'
alias ta='tmux attach -t'
alias tnew='tmux new-session -s'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'
alias tpane='echo $TMUX_PANE'

# convenience aliases for editing configs
alias ev='vim ~/.vimrc'
alias et='vim ~/.tmux.conf'
alias ez='vim ~/.zshrc'
alias ei='vim ~/dotfiles/init.lua'
alias ea='vim ~/.config/alacritty/alacritty.yml'

# for suspend
alias sus="sudo systemctl suspend"
alias halt="sudo systemctl halt"

# jupyter remote
alias jlremote='f(){ jupyter lab --ip 0.0.0.0 --port=$1}; f'
alias addenv='f(){ python -m ipykernel install --user --name=$1}; f'

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

export KEYTIMEOUT=1

setopt rm_star_silent

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Function for creating directories
function make_directories () {
    mkdir $1 
    mkdir -p $1/build
    mkdir -p $1/include 
    mkdir -p $1/src
}

function cpp_project() {
    pwd=$PWD
    mkdir $1 
    cd $1 
    mkdir src include 
    touch CMakeLists.txt
    touch src/main.cpp
    cat << EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.17.5)
project($1)
set(CMAKE_CXX_STANDARD 17 VERSION 0.0.1 LANGUAGES CXX)
set(SRC_FILES src/main.cpp)
add_executable(${PROJECT_NAME} ${SRC_FILES})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE RelWithDebInfo)
EOF
}

vf() {
    LAST_FILE="$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')"
    [[ -n $LAST_FILE ]] && echo "$LAST_FILE" && nvim "$LAST_FILE"
}

cf() {
    _VAR =$(fzf)
    _directory="$(dirname $_VAR)"
    cd $directory
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
