#!/usr/bin/zsh

echo "bootstrapping..."
echo
echo "set alt-tab to cycle within the current workspace"
dconf write /org/gnome/shell/app-switcher/current-workspace-only 'true'
echo

# make sure the extensions folder exists
mkdir -p ~/.local/share/gnome-shell/extensions 2>/dev/null

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

# disable the freaking arrow
install-gnome-extension disable-workspace-switcher-popup@github.com git://github.com/windsorschmidt/disable-workspace-switcher-popup

# disable window title bar when maximized
NAME=maximus-two@wilfinitlike.gmail.com
REPO=https://github.com/wilfm/GnomeExtensionMaximusTwo.git
# maximus
echo "install $NAME"
if ! [ -d ~/.local/share/gnome-shell/extensions/$NAME ] ; then
    git clone $REPO /tmp/$NAME
    cd /tmp/$NAME
    git checkout version4
    mv /tmp/$NAME/$NAME ~/.local/share/gnome-shell/extensions/
    rm /tmp/$NAME -rf
else
  echo "   ... extension already installed";
fi
gnome-shell-extension-tool -e $NAME
echo
