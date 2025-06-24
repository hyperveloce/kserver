
# Homelab System & Project Setup

This guide provides everything you need to set up your homelab environment, including system configuration (SSH, display, networking), and deploying services like Immich, Nextcloud and Home Assistant using Docker and Docker Swarm.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Table of Contents

- [Overview](#overview)
- [System Setup](#system-setup)
  - [SSH Setup](#ssh-setup)
  - [Display Resolution](#display-resolution)
  - [Mount Network Drives](#mount-network-drives)
- [Project Stack](#project-stack)
  - [Prerequisites](#prerequisites)
  - [Docker & Environment Setup](#docker--environment-setup)
  - [Nextcloud Configuration](#nextcloud-configuration)
  - [Home Assistant Configuration](#home-assistant-configuration)
  - [Proxy Configuration](#proxy-configuration)
- [Maintenance](#maintenance)
- [Contact](#contact)

---

## Overview

This project sets up a self-hosted environment using Docker Swarm to run services like:

- **Nextcloud** – private file storage
- **Home Assistant** – home automation
- And other services integrated with Docker, networking, and security best practices.

---

## System Setup

### SSH Setup

Generate a secure SSH key and copy it to your clipboard:

```bash
ssh-keygen -o -t rsa -C "your-email@example.com"
sudo apt install xclip git
xclip -sel clip < ~/.ssh/id_rsa.pub
```

Use the copied key to connect to services like GitHub or remote systems.

---

### Display Resolution

To set a custom display resolution:

```bash
sudo nano /etc/default/grub
```

Update/add these lines:

```bash
GRUB_GFXMODE=2560x1440
GRUB_GFXPAYLOAD_LINUX=2560x1440
GRUB_CMDLINE_LINUX="video=2560x1440"
```

Then update GRUB and reboot:
```bash
sudo update-grub
sudo reboot
```

---

## Project Stack

### Prerequisites

Ensure the following are installed:

- [Docker Compose](https://www.docker.com/products/compose)

---

### Docker & Environment Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/project-name.git
   cd project-name
   ```

2. Setup environment and secrets:

   ```bash
   ln -s /srv/data/secrets.env /home/kanasu/git.hyperveloce/kserver/.env

   docker swarm init

   # Create secrets
   for name in mysql_password mysql_root_password mysql_user admin_password cloudflare_token; do
     read -s -p "Enter $name: " password && echo "$password" | docker secret create $name -
   done

   sudo docker secret ls
   ```

3. Environment variable setup:

   ```bash
   echo 'USERDIR=/home/kanasu/kserver' | sudo tee -a /etc/environment
   read -s -p "Enter Restic password: " password && echo "$password" | sudo tee /home/kanasu/kserver/restic-pw.txt > /dev/null
   ```

---

## Nextcloud Configuration

### Docker Environment

Modify your container settings to:

```env
PHP_UPLOAD_MAX_SIZE=5G
PHP_MEMORY_LIMIT=1024M
APC_SHM_SIZE=256M
OPCACHE_MEM_SIZE=256M
CRON_PERIOD=10m
MEMCACHE_LOCAL='\OC\Memcache\Redis'
```

### `config.php` trusted proxy config

```php
'trusted_proxies' => ['172.21.0.7'],
'overwriteprotocol' => 'https',
'trusted_domains' => [
  '192.168.50.201:8080',
  'nextcloud.dnaone.love',
],
```

---

## Maintenance

```bash
./scripts/update-all.sh
./scripts/update-docker.sh
```

---

## Contact

> Replace this section with your contact information if needed.
