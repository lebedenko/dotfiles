#!/bin/sh

DOTFILES=$HOME/dotfiles

ln -sf $DOTFILES/.ctags $HOME/.ctags
ln -sf $DOTFILES/.vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
ln -sf $DOTFILES/.vim/vimrc $HOME/.vim/vimrc
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.gtkrc-2.0 $HOME/.gtkrc-2.0
mkdir -p $HOME/.config/alacritty
ln -sf $DOTFILES/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
ln -sf $DOTFILES/.config/compton.conf $HOME/.config/compton.conf
mkdir -p $HOME/.config/conky
ln -sf $DOTFILES/.config/conky/conky.conf $HOME/.config/conky/conky.conf
mkdir -p $HOME/.config/fontconfig/conf.d
ln -sf $DOTFILES/.config/fontconfig/conf.d/10-nerd-icons.conf $HOME/.config/fontconfig/conf.d/10-nerd-icons.conf
ln -sf $DOTFILES/.config/fontconfig/conf.d/78-Reject.conf $HOME/.config/fontconfig/conf.d/78-Reject.conf
mkdir -p $HOME/.config/gtk-3.0
ln -sf $DOTFILES/.config/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini
mkdir -p $HOME/.config/ranger
ln -sf $DOTFILES/.config/ranger/rc.conf $HOME/.config/ranger/rc.conf

