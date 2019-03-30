#!/bin/sh

DOTFILES=$HOME/dotfiles

ln -sf $DOTFILES/.ctags $HOME/.ctags
ln -sf $DOTFILES/.vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
ln -sf $DOTFILES/.vim/vimrc $HOME/.vim/vimrc
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.gtkrc-2.0 $HOME/.gtkrc-2.0

