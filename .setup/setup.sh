#!/bin/bash

cd ~

# --- install oh my zsh

sudo apt-get install git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set up symlinks

sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
sudo apt-get update && sudo apt-get install rcm

rcup -v
