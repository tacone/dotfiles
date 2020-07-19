#!/bin/bash

cd ~

# --- install oh my zsh

sudo apt-get install git zsh curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# --- filewatch

sudo apt-get install inotify-tools

# --- vim

sudo apt-get install vim

# --- grc (command output highlighting)

sudo apt-get install grc

# --- fonts

sudo apt-get install fonts-powerline

# --- howdoi

pip3 install howdoi

# set up symlinks

sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
sudo apt-get update && sudo apt-get install rcm

rcup -v

# node!

wget -qO- https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get update
sudo apt-get install -y nodejs

npm install -g npm-check-updates