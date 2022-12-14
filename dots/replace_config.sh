#!/bin/bash

## Make the rc files executable
chmod +x ./bspwm/bspwmrc
chmod +x ./polybar/launch.sh

## Add Wallpaper to ~/Pictures
mkdir -p ~/Pictures
cp ../misc/wallpaper.jpg ~/Pictures/

## Remove previous configs
rm -rf ~/.config/sxhkd/
rm -rf ~/.config/picom/
rm -rf ~/.config/polybar/
rm -rf ~/.config/kitty/
rm -rf ~/.config/bspwm/
rm -rf ~/.config/fish/
rm -rf ~/.config/gtk-3.0/

## Place files at the filesystem
cp -r ./bspwm/ ~/.config/
cp -r ./kitty/ ~/.config/
cp -r ./picom/ ~/.config/
cp -r ./sxhkd/ ~/.config/
cp -r ./polybar/ ~/.config/
cp -r ./fish/  ~/.config/
cp -r ./gtk-3.0/ ~/.config/
cp -r ./nvim/   ~/.config/
cp ./X11/.xinitrc ~/
