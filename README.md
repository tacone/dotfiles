My dotfile collection, made with [RCM](https://thoughtbot.github.io/rcm/)

How to install RCM on Ubuntu

```shell
sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
sudo apt-get update && sudo apt-get install rcm
```

Then clone this repository in the .dotfiles directory:

```
cd ~
git clone https://github.com/tacone/dotfiles.git .dotfiles
```

Then restore all the symlinks with:

```
rcup -v
```
