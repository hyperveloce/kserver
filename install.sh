#!/bin/bash

Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
 echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
 exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# ##Move home directory
# #  #lsblk - find drive to mount
# sudo mkdir /mnt/w.System
# sudo mount /dev/nvme0n1p2 /mnt/w.System
# sudo mkdir /mnt/b.System
# sudo mount /dev/nvme1n1p1 /mnt/b.System
# sudo mkdir /mnt/hyper.space
# sudo mount /dev/sdb2 /mnt/hyper.space
# sudo mkdir /mnt/kanasu.space
# sudo mount /dev/sda3 /mnt/kanasu.space

#sudo mkdir -p /mnt/home
#sudo mount /dev/sdb2 /mnt/home
#sudo df -Th
#sudo cp -aR /home/* /mnt/home
#ls -larth /mnt/home/kanasu

# System updates
sudo apt update && sudo apt upgrade

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds
# cp -R dotconfig/* /home/$username/.config/
# cp bg.jpg /home/$username/Pictures/backgrounds/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username

# # Install nala
apt install nala -y

# Installing Essential Programs
apt install x11-xserver-utils unzip wget build-essential git samba smbclient cifs-utils neofetch neovim rsync xserver-xorg xterm docker-compose-y

# # Beautiful bash
# bash scripts/setup.sh

# Use nala
bash scripts/usenala

sudo apt autoremove

printf "\e[1;32mYour system is ready and will go for reboot! Thanks you.\e[0m\n"

systemctl reboot
