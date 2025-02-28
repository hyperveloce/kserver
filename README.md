### Resolution setup

```bash
sudo nano /etc/default/grub
```

GRUB_GFXMODE=2560x1440
GRUB_GFXPAYLOAD_LINUX=2560x1440
GRUB_CMDLINE_LINUX="video=2560x1440"

```bash
Run sudo update-grub
```

### Mount network drives

```bash
lsblk -f
sudo vim /etc/fstab
sudo mkdir -p /mnt/asusax6000/backup;
```

//192.168.50.1/backup /mnt/asusax6000/backup cifs vers=1.0,username=Kanasu,password==$$$$$,domain=WORKGROUP 0 0
```bash
systemctl daemon-reload
```

##### SMBsetup -- https://www.zdnet.com/article/how-to-share-folders-to-your-network-from-linux/


##### Homepage -- https://technotim.live/posts/homepage-dashboard/#configure

2FAuth
Grafana
Prometheus
github actions -- https://github.com/nektos/act
OPNSense
Pi-hole
malTrail
Ntopng
monit
PiAlert
LibreSpeed
StatPing
NetData
ArchiveBox
Wallabag
vault-warden
Wiki?
https://github.com/lus/pasty
https://searx.thegpm.org/
https://www.pufferpanel.com/


Calibre
Muximux
Organizr 
Veeam - Learn Veeam to backup your VMs
Networking --
GNS3
pfSense
OPNsense
Pi-hole
OpenVPN
VyOS
IPFire
Monitoring --
