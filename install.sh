#!/bin/sh

DOTFILES=$HOME/repos/dotfiles

#
# setup ZSH
#

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
mv $HOME/.zshrc $HOME/.zshrc.before-dotfiles
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.aliases $HOME/.aliases
ln -sf $DOTFILES/.p10k.zsh $HOME/.p10k.zsh
ln -sf $DOTFILES/.fzf.zsh $HOME/.fzf.zsh
source $HOME/.zshrc

#
# setup configs
#

# ln -sf $DOTFILES/.config/alacritty $HOME/.config/alacritty
# ln -sf $DOTFILES/.config/bat $HOME/.config/bat

#
# setup neovim
#

# git clone --depth 1 https://github.com/wbthomason/packer.nvim\
#   $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
#
# [ -d $HOME/.config/nvim ] || mkdir -p $HOME/.config/nvim
#
# ln -sf $DOTFILES/.config/nvim/after $HOME/.config/nvim/after
# ln -sf $DOTFILES/.config/nvim/lua $HOME/.config/nvim/lua
# ln -sf $DOTFILES/.config/nvim/init.lua $HOME/.config/nvim/init.lua

#
# setup tmux
#

# mkdir -p $HOME/.config/tmux/plugins

# git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

# ln -sf $DOTFILES/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
# ln -sf $DOTFILES/.config/systemd/user/tmux.service $HOME/.config/systemd/user/tmux.service
