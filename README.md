<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#arch">Arch</a></li>
  </ol>
</details>

# [Arch](https://wiki.archlinux.org/title/Arch_Linux) [<img src="https://github.com/SfikasTeo/Arch/blob/main/ArchLogo2.png" width="220" align="right" alt="Arch">](https://wiki.archlinux.org/)
Arch Linux is a barebone linux distribution with a **minimal** ISO focused on the KISS principle. Arch strives to provide the latest software
releases based on a **rolling release** model. Arch does not target a selected use case but a user mentality of "do-it-yourself", although the 
rolling release model may be prone to **user error** and unstable for server use.  
Lastly Arch follows Linux Foundation's Filesystem Hierarchy Standard ([FHS](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)), and the package management is based on [Pacman](https://wiki.archlinux.org/title/Pacman).  
    
**Disclaiming**: The following guide will be customized and specific for my set-up process.  Alternating the guide to your needs is advisable. 

## Starting up: The main resources that will be of use for the installation Guide

* [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
* [Arch Wiki](https://wiki.archlinux.org/)
* [Arch Package Manager](https://wiki.archlinux.org/title/Pacman)
* [EFI System Partition](https://wiki.archlinux.org/title/EFI_system_partition#GPT_partitioned_disks)
* [BootLoaders Comparisson](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader)

## [Installation](https://wiki.archlinux.org/title/Installation_guide#Boot_the_live_environment) Proccess

* Default user will be nixos -> `sudo su` -> root user
* Check for Internet Access ip -a. Check [Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-booting-networking) for Wifi support
* Configuring **Partitions** and **Filesystems**:
	* `lsblk -f` or `fdisk -l` -> List drives  
	* `blkdiscard /dev/sda` -> Updates the drives firmware to signify that the drive is empty (**SSD** or **NVME** only).  
  	* Partition Disk ( `/dev/sda` ):    
          Any supported partition utility could be used. We will default to GNU **parted** -> `parted`  
		* Create a **gpt** partition table -> `mklabel gpt`
		* Create the partitions:  
		```
		mkpart NIXBOOT fat32 4mb 1gb  
		mkpart NIXBTRFS btrfs 1gb 100%
		set 1 esp on
		```
	* Create the filesystems:
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
* Login as `root` from tty ( **Cntr + Alt + Fkeys** ) and change the user passwd -> `passwd sfikas`

## [Nix Package Management](https://nixos.wiki/wiki/Nix_package_manager)  

	
				
