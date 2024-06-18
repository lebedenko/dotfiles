#!/bin/sh

DOTFILES=$HOME/repos/dotfiles

# setup ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
mv $HOME/.zshrc $HOME/.zshrc.before-dotfiles
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.aliases $HOME/.aliases
ln -sf $DOTFILES/.p10k.zsh $HOME/.p10k.zsh
ln -sf $DOTFILES/.fzf.zsh $HOME/.fzf.zsh
source $HOME/.zshrc

# setup configs
ln -sf $DOTFILES/.config/alacritty $HOME/.config/alacritty
ln -sf $DOTFILES/.config/bat $HOME/.config/bat
