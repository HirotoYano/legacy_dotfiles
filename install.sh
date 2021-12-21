#!/bin/bash
set -e

use_package_manager() {
  if type "brew" > /dev/null 2>&1; then
    brew install vim
    brew install tmux
  elif type "apt-get" > /dev/null 2>&1; then
    curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep "browser_download_url.*nvim.appimage\"" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | xargs curl -o ~/nvim.appimage -L
    chmod u+x ~/nvim.appimage
    ~/nvim.appimage --appimage-extract
    echo export PATH=$PATH:$HOME/squashfs-root/usr/bin >> ~/.bash_local
  else
    echo "Your os is not supported."
  fi
}

touch ~/.bash_local

use_package_manager

git clone https://github.com/uji/vimrc.git ~/dotfiles/vimrc
sh ~/dotfiles/vimrc/install.sh

mkdir -p ~/.config
ln -sf ~/dotfiles/vimrc/.vimrc ~/.vimrc
ln -sf ~/dotfiles/vimrc/vim ~/.vim
ln -sf ~/dotfiles/vimrc/vim ~/.config/nvim
ln -sf ~/dotfiles/vimrc/.vimrc ~/.config/nvim/init.vim
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

source ~/.bashrc

if type "nvim" > /dev/null 2>&1; then
  nvim -c 'call minpac#clean()' \
      -c 'call minpac#update("", {"do": "quit"})' \
      -c ':q'
else
  vim -c 'call minpac#clean()' \
      -c 'call minpac#update("", {"do": "quit"})' \
      -c ':q'
fi
