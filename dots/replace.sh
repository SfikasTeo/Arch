#!/bin/bash

## Make the rc files executable
chmod +x ./bspwm/bspwmrc
chmod +x ./polybar/launch.sh

## Configure Fontconfig
mkdir ~/.config/fontconfig
cp ./fontconfig/fonts.conf ~/.config/fontconfig

# Remove Noto Default Configurations
rm -rf /etc/fonts/conf.d/66-noto-sans.conf
rm -rf /etc/fonts/conf.d/66-noto-mono.conf
rm -rf /etc/fonts/conf.d/66-noto-serif.conf

# Add FiraCode as Default Font
cp -r ./fontconfig/conf.d/* /etc/fonts/conf.d/

## Add Wallpaper to ~/Pictures
mkdir ~/Pictures
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
cp -r ./polybar ~/.config/
cp -r ./fish/  ~/.config/
cp -r ./gtk-3.0 ~/.config/
cp ./X11/.xinitrc ~/

## Add Keyboard Configuration
cp ./X11/00-keyboard.conf /etc/X11/xorg.conf.d/

