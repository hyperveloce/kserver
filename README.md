### Resolution setup
sudo nano /etc/default/grub

GRUB_GFXMODE=2560x1440
GRUB_GFXPAYLOAD_LINUX=2560x1440
GRUB_CMDLINE_LINUX="video=2560x1440"





#monitor off
Edit /etc/default/grub
Find the line with GRUB_CMDLINE_LINUX="foo=bar"
Add the parameter: GRUB_CMDLINE_LINUX="consoleblank=60 foo=bar"
Run sudo update-grub

###Move home directory --

lsblk -f
sudo vim /etc/fstab
UUID=1934d250-44a9-4860-90e8-367a33eb3fbd /mnt/kserver.system ext4 rw,user,nofail 0 0

//192.168.50.2/k_media /media/asus87u/k_media cifs vers=1.0,username=Kanasu,password==$$$$$,domain=WORKGROUP 0 0
//192.168.50.2/k_Cinema /media/asus87u/k_Cinema cifs vers=1.0,username=Kanasu,password=$$$$$,domain=WORKGROUP 0 0
//192.168.50.1/backup /media/asusax6000/backup cifs vers=1.0,username=Kanasu,password==$$$$$,domain=WORKGROUP 0 0
//192.168.50.201/kserver-home /media/kserver/kserver-home cifs username=Kanasu,password==$$$$$,domain=WORKGROUP 0 0

sudo mkdir -p /media/asus87u/k_media;
sudo mkdir -p /media/asus87u/k_Cinema;
sudo mkdir -p /media/asusax6000/backup;
sudo mkdir -p /media/kserver/kserver-home;

sudo mkdir /mnt/kserver.system
systemctl daemon-reload

SMBsetup --https://www.zdnet.com/article/how-to-share-folders-to-your-network-from-linux/

#suspend sleep
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
#re-enable sleep
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

sudo vim /etc/environment
PUID=????
PGID=????
TZ="Australia/Melbourne"
USERDIR="/home/kanasu/kserver

sudo vim /etc/host


MUST Install
Homepage
https://technotim.live/posts/homepage-dashboard/#configure

2FAuth
Grafana
Prometheus

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



Headphones - manage your music.
MadSonic - stream your music collection.
Calibre - eBook server
Muximux - lightweight portal to manage your webapps.
Organizr - Another feature-packed lightweight portal to manage your webapps.
Game servers - Host a Minecraft server to play privately with friends or because you enjoy playing god.
Tautulli - tons of stats for your Plex server's usage. (Formally PlexPy)
Mylar - manage your comic books.
NZBHydra - NZB Indexer aggregator, similar in form to Jackett.
Veeam - Learn Veeam to backup your VMs
Networking --
GNS3
pfSense
OPNsense
Pi-hole
Network Monitor
OpenVPN
VyOS
IPFire
Monitoring --
Splunk - data analytics and logging, including a SYSLOG server
Syslog - log collation built into *nix to feed Splunk (or other Security Information Event Manager)
Security Software
Snort - intrusion prevention software (IPS)
Infrastructure Tools
Chef, Puppet, or Ansible - server configuration and deployment managers, heavily used in data centers
**** Guacamole clientless remote gateway to access your server from elsewhere
