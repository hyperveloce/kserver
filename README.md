# System Setup Guide

This guide provides instructions for setting up SSH, configuring display resolution, mounting network drives, and integrating monitoring tools for your system.

---

## 1. SSH Setup

Generate an SSH key and copy it to your clipboard for use with GitHub or other services.

Generate an SSH key
```bash
ssh-keygen -o -t rsa -C "davie.nguyen@gmail.com"
```
Install xclip and git (if not already installed)
```bash
sudo apt install xclip git
```
Copy the SSH public key to the clipboard
```bash
xclip -sel clip < ~/.ssh/id_rsa.pub
```

---

## 2. Display Resolution Setup

Adjust the GRUB configuration to set a custom display resolution.

```bash
sudo nano /etc/default/grub
```
Add or update the following lines in the file:

```bash
GRUB_GFXMODE=2560x1440
GRUB_GFXPAYLOAD_LINUX=2560x1440
GRUB_CMDLINE_LINUX="video=2560x1440"
```
Save the file and update GRUB:
```bash
Run sudo update-grub
```
Reboot your system to apply the changes.


## 3. Mount Network Drives

Set up network drives using cifs to mount shared folders.

Step 1: Identify Available Drives
```bash
lsblk -f
```
Step 2: Edit the fstab File
```bash
sudo vim /etc/fstab
```
Add the following line to mount the network drive:
```bash
//192.168.50.1/backup /mnt/asusax6000/backup cifs vers=1.0,username=Kanasu,password=$$$$$,domain=WORKGROUP 0 0
```
Step 3: Create the Mount Point and Reload
```bash
sudo mkdir -p /mnt/asusax6000/backup
sudo systemctl daemon-reload
```

Step 4: Mount the Drive
```bash
sudo mount -a
```
For more details on SMB setup, refer to this https://www.zdnet.com/article/how-to-share-folders-to-your-network-from-linux/
