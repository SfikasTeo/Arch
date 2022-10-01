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

* Set Console Keymap ( US by default ) and select fonts:
	*  List of available Keymaps: 	`ls /usr/share/kbd/keymaps/**/*.map.gz` . Change using `loadkeys <name>` command.
	*  List of available Fonts:	`ls /usr/share/kbd/consolefonts/`. Change using `setfont <name>` command.
* Verify EFI boot mode:	`ls /sys/firmware/efi/efivars` . If the directory exists you are booted into UEFI disk firmware.
* Check for Internet Access ip -a. Check [iwd](https://wiki.archlinux.org/title/Iwd#iwctl) for Wifi connection.
* Update the system clock: `timedatectl set-ntp true`
* Configuring **Partitions** and **Filesystems**:
	* `lsblk -f` or `fdisk -l` -> List drives  
	* `blkdiscard /dev/sda` -> Updates the drives firmware to signify that the drive is empty (**SSD** or **NVME** only).  
  	* [Partition Disk](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks) ( `/dev/sda` ):    
          Any supported partition utility could be used. We will default to GNU **parted** -> `parted`  
		* Create a **gpt** partition table -> `mklabel gpt`
		* Create the partitions:  
		```
		mkpart NIXBOOT fat32 4mb 1gb  
		mkpart NIXBTRFS btrfs 1gb 100%
		set 1 esp on
		```
	* Format the partitions:
	```
	mkfs.fat -F32 -n NIXBOOT /dev/sda1
	mkfs.btrfs -L NIXBTRFS /dev/sda2
	```
	* Create the Btrfs subvolumes:
	```
	mount /dev/sda2 /mnt
	btrfs su cr /mnt/@
	btrfs su vr /mnt/@home
	umount /mnt
	```
	* Mount the Filesystems:
	```
	mount -o ssd,noatime,space_cache=v2,discard=async,compress=zstd:1,subvol=@ /dev/sda2 /mnt
	mkdir /mnt/home
	mount -o ssd,noatime,space_cache=v2,discard=async,compress=zstd:1,subvol=@home /dev/sda2 /mnt/home
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	```
	Should you use btrfs [compression](https://www.reddit.com/r/btrfs/comments/kul2hh/btrfs_performance/) ? What about the other btrfs [mount options](https://btrfs.readthedocs.io/en/latest/btrfs-man5.html) ?
* Update the mirrorlist:
	* Edit `/etc/pacman.d/mirrorlist` manually
	* Install reflector: `pacman -Syy && pacman -S reflector` and use `reflector -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist`
* Install Essential packages using pacstrap:
 ```
 pacstrap /mnt base linux linux-firmware neovim amd-ucode parted man-pages man-db
 ```
 * Configure The system:
 	* Generate and edit **fstab**: `genfstab -U /mnt >> /mnt/etc/fstab` && `cat /mnt/etc/fstab`
 	* Change root into the new system: `arch-chroot /mnt`
 		* Create symlink for timezone : `ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localetime`
 		* Write the current software UTC time to the hardware clock and create `/etc/adjtime` : `hwclock --systohc`
 		* For [Troubleshooting](https://wiki.archlinux.org/title/System_time#Troubleshooting) manually synchronize your clock with the network: `ntpd -qg`
 		* Create locale: `locale-gen` and `echo "LANG=en_US.UTF-8" >> /etc/locale.conf`
 		* If keyboard layout was changed edit `/etc/vconsole.conf`
 		* Edit Hostname: `echo "<SF-Arch>" >> /etc/hostname`
 		* Edit LocalHost: `nvim /etc/hosts`
 		```
		#Standard host addresses
		127.0.0.1	localhost 
		::1		localhost ip6-localhost ip6-loopback
		ff02::1		ip6-allnodes
		ffo2::2		ip6-allrouters
		#This Host Address
		127.0.1.1	SF-Arch
		```
		* Set root  password: `passwd`
		* Install the most **Basic Packages**:
		```
		pacman -S base-devel linux linux-headers networkmanager inetutils git reflector inxi dialog\
		alsa-utils pulseaudio dosfstools ntfs-3g bluez bluez-utils pulseudio-bluetooth xdg-utils \
		```
		

## [Nix Package Management](https://nixos.wiki/wiki/Nix_package_manager)  

	
				
