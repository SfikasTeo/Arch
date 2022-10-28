#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Try using sudo."
    exit 2
fi

## Configure Fontconfig
mkdir -p ~/.config/fontconfig
cp ./fontconfig/fonts.conf ~/.config/fontconfig

# Remove Noto Default Configurations
rm -rf /etc/fonts/conf.d/66-noto-sans.conf
rm -rf /etc/fonts/conf.d/66-noto-mono.conf
rm -rf /etc/fonts/conf.d/66-noto-serif.conf

# Add FiraCode as Default Font
cp -r ./fontconfig/conf.d/* /etc/fonts/conf.d/

## Add Keyboard Configuration
cp ./X11/00-keyboard.conf /etc/X11/xorg.conf.d/
