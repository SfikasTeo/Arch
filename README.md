<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#arch">Arch</a></li>
  </ol>
</details>

# [Arch](https://wiki.archlinux.org/title/Arch_Linux) [<img src="https://github.com/SfikasTeo/Arch/blob/main/Arch_Logo.png" width="220" align="right" alt="Arch">](https://wiki.archlinux.org/)
Arch Linux is a barebone linux distribution with a **minimal** ISO focused on the KISS and 'Do-it-yourself' principles. Striving to provide the latest software releases, the distribution is based on a **rolling release** model.  
Lastly Arch follows Linux Foundation's Filesystem Hierarchy Standard ([FHS](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)), and the package management is based on [Pacman](https://wiki.archlinux.org/title/Pacman).  
    
**Disclaiming**: The following guide will be customized and specific for my set-up process.  Alternating the guide to your needs is advisable. 

## Starting up: The main resources that will be of use for the installation Guide

* [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
* [Arch Wiki](https://wiki.archlinux.org/)
* [Arch Package Manager](https://wiki.archlinux.org/title/Pacman)
* [EFI System Partition](https://wiki.archlinux.org/title/EFI_system_partition#GPT_partitioned_disks)
* [BootLoaders Comparisson](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader)

## [Installation](https://wiki.archlinux.org/title/Installation_guide#Boot_the_live_environment) Proccess

* Set Console Keymap ( US by default ) and select fonts :
	*  List of available Keymaps: 	`ls /usr/share/kbd/keymaps/**/*.map.gz` . Change using `loadkeys <name>` command.
	*  List of available Fonts:	`ls /usr/share/kbd/consolefonts/`. Change using `setfont <name>` command.
* Verify EFI boot mode:	`ls /sys/firmware/efi/efivars` . If the directory exists you are booted into UEFI disk firmware.
* Check for Internet Access: `ip a` . Use [iwd](https://wiki.archlinux.org/title/Iwd#iwctl) for Wifi connection.
* Update the system clock: `timedatectl set-ntp true`
* ##### Configuring **Partitions** and **Filesystems** :
	* `lsblk -f` or `fdisk -l` -> List drives  
	* `blkdiscard /dev/sda` -> Updates the drives firmware to signify that the drive is empty (**SSD** or **NVME** only).  
  	* [Partition Disk](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks) ( `/dev/sda` ):    
          Any supported partition utility could be used. We will default to GNU **parted** -> `parted`  
		* Create a **gpt** partition table -> `mklabel gpt`
		* Create the partitions :  
		```
		mkpart BOOT fat32 4mb 1gb  
		mkpart BTRFS btrfs 1gb 100%
		set 1 esp on
		```
	* Format the partitions :
	```
	mkfs.fat -F32 -n EFI /dev/sda1
	mkfs.btrfs -L ROOT /dev/sda2
	```
	* Create the Btrfs subvolumes :
	```
	mount /dev/sda2 /mnt
	btrfs su cr /mnt/@
	btrfs su vr /mnt/@home
	umount /mnt
	```
	* Mount the Filesystems :
	```
	mount -o rw,ssd,noatime,space_cache=v2,discard=async,compress=zstd:1,subvol=@ /dev/sda2 /mnt
	mkdir /mnt/home
	mount -o rw,ssd,noatime,space_cache=v2,discard=async,compress=zstd:1,subvol=@home /dev/sda2 /mnt/home
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	```
	Should you use btrfs [compression](https://www.reddit.com/r/btrfs/comments/kul2hh/btrfs_performance/) ? What about the other btrfs [mount options](https://btrfs.readthedocs.io/en/latest/btrfs-man5.html) ?
* ##### Update the mirrorlist :
	* Edit `/etc/pacman.d/mirrorlist` manually
	* [Reflector](https://man.archlinux.org/man/reflector.1) : `reflector -l 20 --verbose --sort rate --save /etc/pacman.d/mirrorlist`
* ##### Install Essential packages using pacstrap :
 ```
 pacstrap -i /mnt base sudo linux linux-firmware neovim {amd-ucode or intel-ucode}
 ```
 * ##### Configure The system :
 	* Generate and edit **fstab** : `genfstab -L /mnt >> /mnt/etc/fstab` && `cat /mnt/etc/fstab`
 	* Change root into the new system : `arch-chroot /mnt`
 		* Create symlink for timezone : `ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localetime`
 		* Synchronize hardware and system clock, create `/etc/adjtime` : `hwclock --systohc --localtime`
 			* [Troubleshooting](https://wiki.archlinux.org/title/System_time#Troubleshooting): `ntpd -qg`
 		* Edit `/etc/locale.gen` and **uncomment** `en_US.UTF-8 UTF-8`
		* Create the [locale](https://wiki.archlinux.org/title/Locale): `locale-gen` and `echo "LANG=en_US.UTF-8" >> /etc/locale.conf`
 		* If keyboard layout was changed edit `/etc/vconsole.conf`
 		* Edit Hostname : `echo "SF-Arch" >> /etc/hostname`
 		* Edit LocalHost : `nvim /etc/hosts`
 		```
		#Standard host addresses
		127.0.0.1	localhost 
		::1		localhost ip6-localhost ip6-loopback
		ff02::1	ip6-allnodes
		ffo2::2	ip6-allrouters
		#This Host Address
		127.0.1.1	SF-Arch
		```
		* Set root  password: `passwd`
		* Install **minimal Packages** :
		```
		pacman -S base-devel linux-headers networkmanager dialog wpa_supplicant btrfs-progs fish git
		```
		* Set up the initramfs :
			* **Update** `/etc/mkinitcpio.conf` with `MODULES=(btrfs)` and remove `HOOKS=( fsck )`
			* Recreate initramfs with `mkinitcpio -p linux`
		* Create **user**: `useradd -mG users,wheel,audio,video -s /bin/fish sfikas` and `passwd sfikas`
		* Edit `/etc/sudoers` file: `EDITOR=nvim visudo` and **uncomment** `%wheel ALL=(ALL) ALL`
		* Set up **systemd-boot**
			* **Warning**  This will work only on UEFI.
			* Setup systemd-boot : `bootctl --path=/boot install`
			* Create your bootloader enty : `nvim /boot/loaders/entries/arch.conf`
			```
			title Arch Linux
			linux /vmlinuz-linux
			initrd {/amd-ucode.img or /intel-ucode.img}
			initrd /initramfs-linux.img
			options root=LABEL=ROOT rootflags=subvol=@ rw
			```
			* Set the default bootloader entry : `nvim /boot/loader/loader.conf`   

			```
			default	arch.conf
			timeout	4
			console-mode	max
			editor		no
			```
			* Start NetworkManager Service : `systemctl enable NetworkManager`
		* **Exit** the chroot environment: `exit`
* ##### Unmount the arch partition `umount -R /mnt` and `reboot`

## Install **Basic Packages** :
```
pacman -S inetutils lm_sensors xdg-utils man-pages man-db 	\
openssh reflector dosfstools ntfs-3g parted ttf-fira-code  	\

systemctl enable sshd
```
## Configuring the Desktop :
* #### Configuring [AUR helper](https://wiki.archlinux.org/title/AUR_helpers) :
The suggested aur helpers are either [Yay](https://github.com/Jguer/yay), based on Go, or [Paru](https://github.com/Morganamilo/paru) based on Rust.  
The installation process is almost the same for both.
```
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

* #### Setting up Video drivers :
	* [Intel](https://wiki.archlinux.org/title/intel_graphics#Installation) : `pacman -S xf86-video-intel`
	* [Nvidia](https://wiki.archlinux.org/title/NVIDIA) / [Nouveau](https://wiki.archlinux.org/title/Nouveau)
	* [AMD](https://wiki.archlinux.org/title/AMDGPU) : `pacman -S xf86-video-amdgpu`

* #### Configuring [Xserver](https://wiki.archlinux.org/title/Category:X_server) and [BSPWM](https://wiki.archlinux.org/title/Bspwm) :
	* Install **Xorg** and The **Window manager** :  `pacman -S xorg xorg-xinit bspwm sxhkd picom polybar feh`
	* Install **Audio** functionality : `pacman -S alsa-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth`


* #### Install packages for **Desktop use** :
```
pacman -S flameshot kitty dragon  bluez bluez-utils 	\
blueman network-manager-applet

systemctl enable bluetooth
```

## To Do
* [Power management](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate) Add swap space, if needed and enable [hybernation](https://wiki.archlinux.org/title/systemd-boot#Support_hibernation) throught systemd.
* Guide for Nvidia. AMD or Intel GPU.
* Automation script for steps under installation guide.
* Performance Improvements for desktop use: pacman - booting etc..
* Implement some [General Recommendations](https://wiki.archlinux.org/title/General_recommendations)

	
				
