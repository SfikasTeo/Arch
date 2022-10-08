#! /bin/bash

## Run as root 

if [[ $EUID -ne 0 ]]; then
  echo "You must be super user in order to run this script"
  exit 1
fi

## Make the rc files executable
chmod +x ./bspwm/bspwmrc
# chmod +x ./sxhkd/sxhkdrc


## Place files at the filesystem

cp -r bspwm ~/.config/
cp -r kitty ~/.config/
cp -r picom ~/.config/
cp -r sxhkd ~/.config/
cp -r fish  ~/.config/
cp X11/.xinitrc ~/
