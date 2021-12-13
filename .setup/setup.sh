#!/bin/bash

cd ~

sudo apt-get update

# --- install oh my zsh

sudo apt-get install git zsh curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# --- filewatch

sudo apt-get install -y inotify-tools

# --- vim

sudo apt-get install -y vim

# --- nmap

sudo apt-get install -y nmap

# --- grc (command output highlighting)

sudo apt-get install -y grc


# --- fonts

sudo apt-get install -y fonts-powerline

# --- howdoi

sudo apt-get install -y howdoi

# --- nnn

sudo apt-get install -y nnn

# set up symlinks

sudo apt-get install -y rcm
rcup -v

# node!

wget -qO- https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get update
sudo apt-get install -y nodejs

npm install -g npm-check-updates

# docker

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo gpasswd -a $USER docker
newgrp docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

