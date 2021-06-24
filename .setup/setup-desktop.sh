#!/usr/bin/zsh

echo "bootstrapping..."
echo
echo "set alt-tab to cycle within the current workspace"
dconf write /org/gnome/shell/app-switcher/current-workspace-only 'true'
echo

# make sure the extensions folder exists
#mkdir -p ~/.local/share/gnome-shell/extensions 2>/dev/null

install-gnome-extension() {
  # disable the freaking arrow
  echo "install $1"
  if ! [ -d ~/.local/share/gnome-shell/extensions/$1 ] ; then
      git clone $2 ~/.local/share/gnome-shell/extensions/$1
  else
    echo "   ... extension already installed";
  fi
  gnome-shell-extension-tool -e $1
  echo
}

sudo apt-get install tilix

# visual studio code

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm packages.microsoft.gpg
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code # or code-insiders
sudo apt-get install -y cmatrix
