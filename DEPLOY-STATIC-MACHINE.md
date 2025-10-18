# Deploy Conversation Vault on Static Machine

Guide for deploying the conversation vault on a more permanent/static machine (server, always-on computer, etc.)

## Prerequisites

Your static machine needs:
- **Docker** and **Docker Compose** installed
- **Git** installed
- **Tailscale** installed (for remote access)
- Internet connection
- Sufficient disk space (2-5GB for Docker images + vault data)

## Step-by-Step Deployment

### 1. Install Dependencies (if needed)

**Docker & Docker Compose**:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y docker.io docker-compose git

# Enable Docker to start on boot
sudo systemctl enable docker
sudo systemctl start docker

# Add your user to docker group (optional - avoids needing sudo)
sudo usermod -aG docker $USER
# Log out and back in for this to take effect
```

**Tailscale** (for remote access):
```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale
sudo tailscale up

# Get your Tailscale IP
tailscale ip -4
```

### 2. Clone the Repository

```bash
# Clone the Compass-Project repo
cd ~
git clone https://github.com/timgrote/Compass-Project.git
cd Compass-Project

# Checkout the conversation vault branch
git checkout feature/conversation-vault
```

### 3. Configure Environment (Optional)

Create `.env` file if you want to customize ports or settings:

```bash
# Copy template
cp .env.template .env

# Edit if needed (optional)
nano .env
```

Default ports:
- Obsidian Web: `3000`
- n8n: `5678`
- Obsidian API: `27123`, `27124`

### 4. Start the Vault

```bash
# Start all services in detached mode
docker compose up -d

# Wait for services to be healthy (30-60 seconds)
docker compose ps

# You should see:
# - compass-obsidian: healthy
# - compass-n8n: healthy
# - compass-postgres: healthy
```

### 5. Verify Deployment

**Check services are running**:
```bash
docker compose ps
```

**View logs** (if any issues):
```bash
# All services
docker compose logs -f

# Just Obsidian
docker compose logs -f obsidian
```

**Test local access**:
```bash
# Should return HTML
curl -I http://localhost:3000
```

**Test from browser on same machine**:
- Open: http://localhost:3000
- You should see Obsidian web interface
- Vault should show conversation folders

### 6. Set Up Remote Access via Tailscale

**Get your machine's Tailscale IP**:
```bash
tailscale ip -4
# Example output: 100.64.1.100
```

**Share with collaborators**:
1. Go to https://login.tailscale.com/admin/machines
2. Click "Share" next to your machine
3. Send invite link to Hunter (or other collaborators)
4. Share access URL: `http://YOUR_TAILSCALE_IP:3000`

**Example**: `http://100.64.1.100:3000`

### 7. Enable Auto-Start on Boot (Recommended)

Make sure Docker starts on boot and restarts services automatically:

```bash
# Enable Docker to start on boot
sudo systemctl enable docker

# Set restart policy (already configured in docker-compose.yaml)
# Containers will auto-restart unless manually stopped
```

The `docker-compose.yaml` already has `restart: unless-stopped` for all services.

### 8. Test from Another Machine

**From your laptop** (or Hunter's machine):
1. Install Tailscale
2. Connect to your tailnet
3. Open: `http://YOUR_STATIC_MACHINE_TAILSCALE_IP:3000`
4. You should see the conversation vault

## Maintenance & Management

### Common Operations

**Stop the vault**:
```bash
cd ~/Compass-Project
docker compose down
```

**Restart the vault**:
```bash
docker compose restart
```

**Update to latest version**:
```bash
cd ~/Compass-Project
git pull origin feature/conversation-vault
docker compose down
docker compose up -d
```

**View logs**:
```bash
docker compose logs -f
```

**Backup vault data**:
```bash
# Create backup directory
mkdir -p ~/backups

# Backup vault data
docker run --rm \
  -v compass-project_vault-data:/data \
  -v ~/backups:/backup \
  alpine tar czf /backup/vault-backup-$(date +%Y%m%d).tar.gz -C /data .

# Backup will be in ~/backups/vault-backup-YYYYMMDD.tar.gz
```

**Restore from backup**:
```bash
# Stop services first
docker compose down

# Restore
docker run --rm \
  -v compass-project_vault-data:/data \
  -v ~/backups:/backup \
  alpine tar xzf /backup/vault-backup-YYYYMMDD.tar.gz -C /data

# Start services
docker compose up -d
```

### Monitor Disk Space

```bash
# Check Docker disk usage
docker system df

# Clean up old images/containers (careful!)
docker system prune -a
```

### Check if Services are Healthy

```bash
# Quick health check
docker compose ps

# Detailed container info
docker compose top
```

## Firewall Configuration

If you have a firewall, **you do NOT need to open ports** if using Tailscale. Tailscale handles secure networking.

If you want local network access (not via Tailscale):
```bash
# Ubuntu/Debian with ufw
sudo ufw allow 3000/tcp comment 'Obsidian Web'
sudo ufw allow 5678/tcp comment 'n8n'
```

**Recommended**: Use Tailscale only, don't expose ports publicly.

## Troubleshooting

### Services won't start

```bash
# Check Docker is running
sudo systemctl status docker

# Check logs for errors
docker compose logs

# Try rebuilding
docker compose down
docker compose up -d --build
```

### Can't access from Tailscale IP

```bash
# Verify Tailscale is running
tailscale status

# Check if port 3000 is listening
sudo netstat -tlnp | grep 3000

# Try accessing from local machine first
curl http://localhost:3000
```

### Vault data seems wrong/missing

```bash
# Check vault directory in container
docker compose exec obsidian ls -la /config/Compass/

# If empty, might need to re-initialize
# Stop services, remove vault volume, restart
docker compose down
docker volume rm compass-project_vault-data
docker compose up -d
```

### Out of disk space

```bash
# Check disk usage
df -h

# Clean up Docker
docker system prune -a --volumes

# Remove old backups
rm ~/backups/vault-backup-*.tar.gz
```

## Security Considerations

**Current Setup** (good for private use):
- ✅ Tailscale provides encrypted connection
- ✅ Not exposed to public internet
- ✅ Only accessible to tailnet members

**Optional Enhancements**:
- Add basic authentication (nginx proxy)
- Add crypto sign-in (Web3 wallet)
- Set up SSL/TLS certificates (if exposing publicly - not recommended)

See `DEPLOYMENT-TEST.md` section "Adding Authentication" for details.

## Automatic Backups (Optional)

Set up daily backups via cron:

```bash
# Create backup script
cat > ~/backup-vault.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d)
docker run --rm \
  -v compass-project_vault-data:/data \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/vault-backup-$DATE.tar.gz -C /data .

# Keep only last 7 days
find $BACKUP_DIR -name "vault-backup-*.tar.gz" -mtime +7 -delete
EOF

# Make executable
chmod +x ~/backup-vault.sh

# Add to crontab (daily at 2am)
(crontab -l 2>/dev/null; echo "0 2 * * * ~/backup-vault.sh") | crontab -
```

## Static Machine Recommendations

**Best practices**:
- Use a machine that stays on 24/7 (server, NUC, always-on desktop)
- Ensure reliable internet connection
- Set up automatic OS updates (but test before applying)
- Monitor disk space (vault will grow over time)
- Enable automatic backups (see above)
- Use static IP or Tailscale for consistent access

**Hardware recommendations**:
- **Minimum**: 2GB RAM, 20GB disk, any modern CPU
- **Recommended**: 4GB RAM, 50GB SSD, dual-core CPU
- **Ideal**: Raspberry Pi 4 (4GB), Intel NUC, or any server

## Next Steps

1. ✅ Services deployed and running
2. ✅ Tailscale configured for remote access
3. ✅ URL shared with collaborators
4. **Start using the vault!**
5. Set up backups (see above)
6. Monitor and maintain

---

## Quick Reference

**URLs**:
- Local: http://localhost:3000
- Tailscale: http://YOUR_TAILSCALE_IP:3000
- n8n automation: http://localhost:5678

**Commands**:
- Start: `docker compose up -d`
- Stop: `docker compose down`
- Logs: `docker compose logs -f`
- Status: `docker compose ps`
- Backup: `~/backup-vault.sh` (if configured)

**Tailscale IP**: `tailscale ip -4`

**Support**: Check logs, review troubleshooting section, or open an issue at https://github.com/timgrote/Compass-Project/issues
