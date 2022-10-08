#!/bin/bash

## Make the rc files executable
chmod +x ./bspwm/bspwmrc

## Remove previous configs
rm -rf ~/.config/sxhkd/
rm -rf ~/.config/picom/
rm -rf ~/.config/kitty/
rm -rf ~/.config/bspwm/
rm -rf ~/.config/fish/

## Place files at the filesystem
cp -r ./bspwm/ ~/.config/
cp -r ./kitty/ ~/.config/
cp -r ./picom/ ~/.config/
cp -r ./sxhkd/ ~/.config/
cp -r ./fish/  ~/.config/
cp ./X11/.xinitrc ~/
