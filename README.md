# KServer Homelab

KServer is the main homelab server running Docker services for photos, files, home automation, monitoring, networking, and backups.

## System

- Hostname: `kserver`
- OS: Debian 13 (Trixie)
- Kernel: `6.12.107+deb13-amd64`
- CPU: Intel Core i7-10700T
- RAM: 15 GiB
- Docker root directory: `/srv/docker-data`
- Project directory: `/home/kanasu/git.hyperveloce/kserver`
- Git remote: `git@github.com:hyperveloce/kserver.git`

## Docker

KServer currently uses the Debian-provided Docker packages.

Current package versions:

- Docker Engine: `26.1.5`
- Docker Compose: `2.26.1`
- containerd: `1.7.24`
- runc: `1.1.15`

Docker CE migration is intentionally deferred.

Useful checks:

```bash
sudo systemctl status docker
docker version
docker compose version
sudo docker ps -a
```

## Docker Services

### Photos and Media

- Immich Server
- Immich Machine Learning
- Immich PostgreSQL
- Immich Redis
- Frigate

Immich is currently running version `3.2.4`.

Frigate is present in the Compose configuration but is intentionally stopped.

### Files and Cloud

- Nextcloud
- Nextcloud MariaDB
- Nextcloud Redis
- Syncthing

### Home Automation

- Home Assistant
- Home Assistant MariaDB

### Monitoring and Administration

- Homepage
- Beszel
- Beszel Agent
- Dozzle
- Glances
- Uptime Kuma
- phpMyAdmin
- Speedtest Tracker

### Networking and Access

- Caddy
- Cloudflared
- Docker Socket Proxy
- Tailscale

### Other Services

- Ollama
- IT Tools
- PairDrop

Not every Docker container is exposed through Caddy or shown as a Homepage shortcut. Internal databases, Redis services, agents, and infrastructure containers remain internal.

## Homepage

Homepage is the main KServer dashboard.

Current shortcuts include:

- Immich
- Nextcloud
- Home Assistant
- Beszel
- Dozzle
- Glances
- Speedtest
- IT Tools
- PairDrop
- Syncthing

Uptime Kuma and Frigate are not currently Homepage shortcuts.

Homepage configuration is stored outside this Git repository.

## Caddy

Caddy provides HTTPS reverse-proxy access to selected services.

Current Caddy routes include:

- Immich
- Nextcloud
- Home Assistant
- Frigate
- Homepage
- Beszel
- Dozzle
- Glances
- phpMyAdmin
- Syncthing
- Speedtest
- IT Tools
- PairDrop
- Uptime Kuma

Cloudflare DNS is used for TLS certificates.

The Caddy configuration is stored outside this Git repository.

## Storage

Important KServer data locations include:

```text
/srv/dna-library/photos-videos/
/srv/dna-library/storage-files/
/srv/dna-library/nextcloud-data/
/srv/dna-library/immich-data/
/srv/docker-data/
```

Docker uses `/srv/docker-data` as its Docker root directory.

## Backups

KServer performs scheduled backups to a Synology NAS.

The main backup scripts are:

```text
/usr/local/bin/kserver.backup-photos.sh
/usr/local/bin/kserver.backup-storage-files.sh
/usr/local/bin/kserver.backup-to-nas.sh
```

A wrapper is also available:

```text
/usr/local/bin/kserver-backup
```

Run all backups manually:

```bash
sudo kserver-backup
```

The backup system covers the KServer photo/video library, storage files, and NAS/database backup tasks.

NAS connection details and backup secrets are stored outside Git.

## Backup Monitoring

The backup watchdog is:

```text
/usr/local/bin/kserver.check-backups.sh
```

Run it manually:

```bash
sudo /usr/local/bin/kserver.check-backups.sh
```

The watchdog checks backup freshness and status and integrates with Uptime Kuma.

## Scheduled Jobs

The root crontab currently contains:

```text
02:00 Sunday  - photo backup
03:00 Sunday  - storage files backup
04:00 Sunday  - NAS backup
10:00 daily   - backup health check
05:00 monthly - Docker cleanup
```

View the root crontab:

```bash
sudo crontab -l
```

## Docker Cleanup

The conservative Docker cleanup script is:

```text
/usr/local/bin/kserver.docker-cleanup.sh
```

It removes:

- dangling Docker images
- unused Docker build cache

It deliberately does not automatically remove:

- stopped containers
- tagged images
- Docker volumes

This protects intentionally stopped services and retained rollback images.

## Health Check

The main KServer health check is:

```text
/usr/local/bin/kserver-health
```

Run it with:

```bash
sudo kserver-health
```

The health check reports:

- failed systemd services
- disk usage
- memory and swap
- Docker service status
- Docker container status
- Immich status
- backup status
- exited containers

An exited container is not automatically considered a failure because some services may intentionally be stopped.

## Immich

Immich is currently version `3.2.4`.

The machine-learning container uses the OpenVINO image and has access to the Intel GPU through `/dev/dri`.

The ML model cache is stored at:

```text
/srv/volume/im_model-cache
```

The photo/video library is mounted read-only into Immich.

The Immich PostgreSQL database uses VectorChord and pgvector.

Older Immich images are intentionally retained for rollback while the current installation is monitored.

## Frigate

Frigate remains in the Docker Compose configuration but is intentionally stopped.

Current state:

```text
frigate - Exited (143)
```

It should not be restarted automatically without reviewing the previous resource and stability issues.

## Git Repository

The KServer project is maintained in Git.

Check the current state:

```bash
git status
```

Review changes:

```bash
git diff
```

Validate the Compose configuration:

```bash
docker compose config --quiet
```

List Compose services:

```bash
docker compose config --services
```

After a change has been reviewed and verified:

```bash
git add <file>
git commit -m "Describe the change"
git push
```

Do not commit secrets or generated configuration containing credentials.

## Secrets

Sensitive configuration is intentionally kept outside Git.

The repository excludes secret configuration such as:

```text
.env
*.env
secrets.env
config/secrets/
```

Do not commit:

- passwords
- API keys
- access tokens
- database credentials
- NAS credentials
- other sensitive secrets

## Change Procedure

For significant KServer changes:

1. Check system health.
2. Check Docker and container status.
3. Confirm backups are recent.
4. Back up important configuration.
5. Make one change at a time.
6. Validate the change.
7. Check service health.
8. Review `git diff`.
9. Commit only after verification.

Avoid destructive operations unless they have been explicitly reviewed.

## Useful Commands

### System

```bash
uptime
df -h / /srv
free -h
systemctl --failed
```

### Docker

```bash
sudo docker ps -a
sudo docker system df
docker compose config --services
```

### KServer

```bash
sudo kserver-health
sudo kserver-backup
sudo /usr/local/bin/kserver.check-backups.sh
```

### Git

```bash
git status
git diff
git log --oneline -10
```
