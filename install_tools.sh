#!/bin/bash

install_zsh() {
    if [ -f /bin/zsh -o -f /usr/bin/zsh ] ; then 
        return 1 
    else 
        sudo apt install zsh
    fi
}
install_zsh

if [[ ! -d $HOME/.oh-my-zsh/ ]]; then 
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

install_neovim () {
	wget https://github.com/neovim/neovim/releases/download/v0.6.0/nvim.appimage
	chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/bin/nvim
}

install_neovim

install_tmux() {
    if [ -f /bin/tmux -o -f /usr/bin/tmux ] ; then 
        return 1 
    else 
        sudo apt install tmux
    fi
}
install_tmux

install_miniconda() {
    curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
    chmod 744 Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh
    rm -f Miniconda3-latest-Linux-x86_64.sh
}

conda init zsh 
conda install pip 
pip install pynvim
pip install neovim

dir=$HOME/dotfiles
files="zshrc tmux.conf" 

if [[ ! -d $HOME/.oh-my-zsh/ ]]; then 
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

cd $dir 

for file in $files; do 
    ln -sf $dir/$file $HOME/.$file
done

mkdir -p $HOME/.config/nvim && ln -sf $dir/init.lua $HOME/.config/nvim/init.lua
mkdir -p ~/.ipython/profile_default && mv ipython_config.py.bak $HOME/.ipython/profile_default/ipython_config.py
