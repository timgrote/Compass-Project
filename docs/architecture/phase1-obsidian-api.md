# Phase 1: Obsidian REST API Architecture

## Overview

Phase 1 establishes the foundation: running Obsidian in Docker with REST API access for programmatic vault interaction.

## Technology Decisions

### Obsidian in Docker: LinuxServer.io Image

**Image:** `lscr.io/linuxserver/obsidian:latest`

**Why this approach:**
- ✅ Official, well-maintained image
- ✅ Runs full Obsidian GUI in Docker
- ✅ Web browser access (no VNC needed)
- ✅ Supports all Obsidian plugins (including Local REST API)
- ✅ Active community and updates

**Alternative approaches considered:**
1. ❌ **Headless Obsidian** - Doesn't exist; Obsidian requires GUI
2. ❌ **Custom REST wrapper** - Would bypass Obsidian's features and plugins
3. ❌ **File system access only** - No plugin support, lose Obsidian functionality

### Obsidian Local REST API Plugin

**Plugin:** `obsidian-local-rest-api` by coddingtonbear
**Repository:** https://github.com/coddingtonbear/obsidian-local-rest-api

**Capabilities:**
- Read, create, update, delete notes
- List vault contents
- Search notes
- Execute Obsidian commands
- Create periodic notes

**Authentication:** API key-based (configured in plugin settings)

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│ Phase 1: Obsidian REST API                              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────┐         │
│  │   Docker: compass-obsidian                 │         │
│  │   Image: linuxserver/obsidian              │         │
│  ├────────────────────────────────────────────┤         │
│  │                                             │         │
│  │  ┌─────────────────────────────────┐       │         │
│  │  │  Obsidian GUI                   │       │         │
│  │  │  (Web-accessible)               │       │         │
│  │  │                                  │       │         │
│  │  │  Plugins:                        │       │         │
│  │  │  - Local REST API ←────────┐    │       │         │
│  │  │  - (others as needed)       │    │       │         │
│  │  └─────────────────────────────┘    │       │         │
│  │                 │                    │       │         │
│  │                 ▼                    │       │         │
│  │  ┌─────────────────────────────┐    │       │         │
│  │  │  Vault Files                 │    │       │         │
│  │  │  /config/vault/              │    │       │         │
│  │  │  - Welcome.md                │    │       │         │
│  │  │  - Telos.md                  │    │       │         │
│  │  │  - Journal/                  │    │       │         │
│  │  │  - Templates/                │    │       │         │
│  │  └─────────────────────────────┘    │       │         │
│  │                                       │       │         │
│  └───────────────────────────────────────┘       │         │
│                                                   │         │
│  Exposed Ports:                                  │         │
│  - 3000: Web UI (HTTP)                           │         │
│  - 3001: Web UI (HTTPS)                          │         │
│  - 27124: REST API                               │         │
│                                                   │         │
│  Volume: vault-data → /config                    │         │
│                                                   │         │
└───────────────────────────────────────────────────┘

External Access:
- Browser: http://localhost:3000 → Obsidian GUI
- API: http://localhost:27124 → REST endpoints
```

## Installation & Setup Process

### 1. Start Container

```bash
# Copy environment template
cp .env.template .env

# Edit .env with your settings (PUID, PGID, TZ)
nano .env

# Start container
docker-compose up -d

# View logs
docker-compose logs -f obsidian
```

### 2. Access Obsidian Web UI

1. Open browser: `http://localhost:3000`
2. Wait for Obsidian to load
3. You'll see the vault template loaded

### 3. Install Local REST API Plugin

**Manual installation** (required for first-time setup):

1. In Obsidian web UI: Settings → Community plugins
2. Turn off "Restricted mode"
3. Browse → Search "Local REST API"
4. Install → Enable
5. Configure API key in plugin settings
6. Copy API key to `.env` file (`API_KEY=your-key-here`)
7. Restart container: `docker-compose restart obsidian`

### 4. Test REST API Access

```bash
# Test API endpoint (replace YOUR_API_KEY)
curl -H "Authorization: Bearer YOUR_API_KEY" \
     http://localhost:27124/

# List vault files
curl -H "Authorization: Bearer YOUR_API_KEY" \
     http://localhost:27124/vault/

# Read a note
curl -H "Authorization: Bearer YOUR_API_KEY" \
     http://localhost:27124/vault/Welcome%20to%20Compass.md
```

## Data Persistence

### Docker Volume: `vault-data`

**Location:** Docker-managed volume (not in repo)
**Maps to:** `/config` inside container
**Contains:**
- Obsidian configuration (`.obsidian/`)
- Vault files (notes, templates, journals)
- Plugin data

**Backup strategy:**
```bash
# Backup volume
docker run --rm \
  -v compass-deployment_vault-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/vault-backup-$(date +%Y%m%d).tar.gz /data

# Restore volume
docker run --rm \
  -v compass-deployment_vault-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/vault-backup-YYYYMMDD.tar.gz -C /
```

## Network Configuration

### Local Access Only (Default)

Ports exposed to `localhost` only:
- Safe for single-user on same machine
- No external network access required

### LAN Access (Optional)

To access from other devices on same network:
1. Bind to all interfaces in `docker-compose.yaml`:
   ```yaml
   ports:
     - "0.0.0.0:3000:3000"  # Instead of 127.0.0.1:3000:3000
   ```
2. Configure firewall to allow ports 3000, 27124
3. Access via `http://YOUR_IP:3000`

**Security note:** Use strong API keys when exposing to network!

### Internet Access (Future)

Options for remote access:
- **Tailscale:** Secure VPN mesh network
- **Cloudflare Tunnel:** Zero-trust tunneling
- **Ngrok:** Quick tunneling for testing
- **VPN:** Traditional VPN access

## Security Considerations

### Phase 1 Security

- ✅ API key authentication required
- ✅ Localhost-only by default
- ✅ No cloud services required
- ⚠️  Web UI has no password (add in Phase 3)
- ⚠️  HTTPS not configured (ports exposed but not used)

### Future Enhancements (Phase 3+)

- Add basic auth to web UI
- Enable HTTPS with self-signed cert
- Implement rate limiting
- Add audit logging

## Testing Checklist

- [ ] Container starts successfully
- [ ] Can access Obsidian web UI at localhost:3000
- [ ] Vault template files are visible
- [ ] Can install Local REST API plugin
- [ ] Can configure API key
- [ ] REST API responds to authenticated requests
- [ ] Can create/read/update notes via API
- [ ] Data persists after container restart
- [ ] Can access from another machine on LAN (if configured)

## Known Limitations & Issues

### Current Limitations

1. **Plugin must be installed manually** on first run
   - Can't pre-install plugins in template
   - Future: Script this or provide detailed instructions

2. **API port not configurable from Obsidian plugin**
   - Hardcoded to 27124 in plugin
   - Docker port mapping works around this

3. **HTTPS requires additional setup**
   - LinuxServer image supports it but needs certs
   - Future: Add Let's Encrypt integration

### WSL-Specific Notes

- PUID/PGID must match WSL user (usually 1000/1000)
- File permissions matter for vault-data volume
- Display may not work if X11 not configured (web UI bypasses this)

## Phase 1 Success Criteria

✅ Obsidian runs in Docker container
✅ Vault template loads correctly
✅ REST API plugin is installable
✅ Can read/write notes programmatically via API
✅ Data persists across container restarts
✅ Accessible from another machine on network (tested)
✅ Documentation clear enough for non-Docker users

## Next Steps: Phase 2

Once Phase 1 is stable:
1. Add n8n container
2. Add PostgreSQL for n8n
3. Create simple n8n workflow that writes to vault via API
4. Test inter-container communication

---

**Last updated:** 2025-10-04
**Status:** In Development
**Branch:** `feature/obsidian-api-basic`
