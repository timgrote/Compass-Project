# Deployment Guide

How to deploy this shared vault for secure remote access.

## Architecture Options

### Option 1: Obsidian Web (Recommended for MVP)

**What it is**: Self-hosted web interface for Obsidian vaults.

**Pros**:
- Single deployment, accessible via browser
- No Obsidian app installation required for collaborators
- You control the infrastructure
- Can run in Docker container

**Cons**:
- Web-only (no desktop app features)
- Need to secure with HTTPS and authentication
- Requires server/hosting

**Setup**:
1. Deploy Obsidian Web instance (Docker or native)
2. Point it at this vault directory
3. Set up HTTPS (Let's Encrypt or reverse proxy)
4. Configure authentication (see Authentication section below)
5. Expose via VPN or secure network (see Network Security below)

### Option 2: Dual Vaults with Sync

**What it is**: Each person runs Obsidian locally, vaults sync via backend.

**Pros**:
- Full Obsidian desktop experience
- Offline access
- Better performance

**Cons**:
- Sync conflicts possible
- Both people need Obsidian installed
- More complex setup

**Setup**:
1. Initialize git repo in vault (or use Obsidian Sync/other sync service)
2. Both people clone/connect to vault
3. Set up sync protocol (git hooks, Obsidian Sync, Syncthing, etc.)
4. Agree on conflict resolution strategy

### Option 3: Relay (True Multiplayer)

**What it is**: Relay provides real-time multiplayer editing in Obsidian.

**Research needed**:
- [ ] Is Relay open source?
- [ ] Can it be self-hosted / container deployed?
- [ ] What's the authentication model?
- [ ] Cost if not self-hosted?

**If viable**: Best of both worlds - local Obsidian + real-time collaboration.

## Authentication

### Basic Auth (MVP)

Simplest approach for Obsidian Web:

```nginx
# Nginx config example
location / {
    auth_basic "Shared Vault";
    auth_basic_user_file /etc/nginx/.htpasswd;
    proxy_pass http://localhost:8080;
}
```

Generate password: `htpasswd -c .htpasswd hunter`

**Pros**: Simple, built-in to web servers
**Cons**: Not crypto-native, shared password

### Crypto Sign-In (Committed Feature)

Use Web3 wallet signing for authentication:

**Architecture**:
1. Frontend: Connect wallet button (MetaMask, WalletConnect)
2. Challenge: Server generates random nonce
3. Sign: User signs nonce with private key
4. Verify: Server verifies signature against allowed public keys
5. Session: Issue JWT or session cookie on success

**Implementation**:
- Frontend: ethers.js or web3.js for signing
- Backend: Verify signature, check against allowlist of public keys
- Store: Allowlist in config file or env var

**Example allowed keys**:
```json
{
  "allowed_signers": [
    "0x1234...Tim's address",
    "0x5678...Hunter's address"
  ]
}
```

**Libraries**:
- [Web3Auth](https://web3auth.io/) - Wallet adapter, handles UX
- [ethers.js](https://docs.ethers.org/) - Signing and verification
- [siwe](https://docs.login.xyz/) - Sign-In with Ethereum standard

### OAuth (Alternative)

Use GitHub/Google OAuth if crypto sign-in isn't priority:

**Pros**: Familiar, well-tested, handles account recovery
**Cons**: Centralized, requires OAuth provider trust

## Network Security

### VPN Access (Recommended)

Deploy Obsidian Web on private network, access via VPN:

**Options**:
- **Tailscale**: Dead simple, peer-to-peer, free for small teams
- **WireGuard**: More control, need to manage configs
- **OpenVPN**: Traditional, well-supported

**Tailscale Setup**:
1. Install Tailscale on server running Obsidian Web
2. Share magic link with Hunter
3. Both connect via Tailscale IPs
4. No public exposure needed

### Reverse Proxy with TLS

If exposing publicly:

```nginx
server {
    listen 443 ssl http2;
    server_name vault.yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Use Let's Encrypt for free TLS certs: `certbot --nginx`

### IP Allowlist

Restrict access to known IPs if possible:

```nginx
location / {
    allow 1.2.3.4;      # Tim's IP
    allow 5.6.7.8;      # Hunter's IP
    deny all;
}
```

**Note**: Works best with static IPs or VPN exit IPs.

## Obsidian Web Configuration

### Docker Deployment

```dockerfile
FROM node:18-alpine

# Install Obsidian Web (hypothetical - check actual project)
RUN npm install -g obsidian-web

# Expose port
EXPOSE 8080

# Set vault path
ENV VAULT_PATH=/vault

# Start server
CMD ["obsidian-web", "--vault", "/vault", "--port", "8080"]
```

Run:
```bash
docker run -d \
  -p 8080:8080 \
  -v /path/to/conversation-vault:/vault \
  obsidian-web
```

### Native Deployment

1. Install Obsidian Web: `npm install -g obsidian-web` (or equivalent)
2. Point to vault: `obsidian-web --vault /path/to/vault --port 8080`
3. Run as systemd service for persistence

### Environment Variables

```bash
VAULT_PATH=/path/to/conversation-vault
PORT=8080
AUTH_METHOD=crypto  # or 'basic', 'oauth'
ALLOWED_SIGNERS=0x1234...,0x5678...
```

## Automation Integration

### Telegram → Vault

Use n8n or similar to pipe Telegram messages into vault:

**Workflow**:
1. Telegram message webhook
2. Parse message content
3. Create/update note in vault
4. (Optional) Notify other person

**n8n nodes**:
- Telegram Trigger
- Function (parse and format)
- Obsidian API or file system write
- (Optional) Telegram send notification

### Voice Transcription

Add voice messages to vault:

**Workflow**:
1. Voice message received (Telegram, etc.)
2. Transcribe via Whisper API or local Whisper
3. Create note in `/Conversations/` with transcription
4. Tag with `#voice-note`

### AI Summaries

Periodic summaries of vault activity:

**Workflow**:
1. Cron job (weekly?)
2. Analyze recent changes (git log or file mtimes)
3. Generate summary via Claude/GPT
4. Post to `/Tim-Notes/` or `/Hunter-Notes/`

## Backup Strategy

### Git-Based

Initialize vault as git repo:

```bash
cd /path/to/conversation-vault
git init
git add .
git commit -m "Initial vault"
```

Daily backup:
```bash
#!/bin/bash
cd /path/to/conversation-vault
git add .
git commit -m "Auto-backup $(date +%Y-%m-%d)"
git push origin main
```

### Filesystem Snapshots

Use rsync or restic for incremental backups:

```bash
rsync -av --delete /path/to/conversation-vault /backup/location
```

### Obsidian Sync

If using Obsidian Sync, it handles versioning automatically.

## Plugins to Enable

Recommended Obsidian plugins for shared vault:

- **Templater**: For the templates in `/.templates/`
- **Dataview**: Query and display notes dynamically
- **Kanban**: Project boards (if you add projects)
- **Calendar**: Visualize dated notes
- **Excalidraw**: Collaborative diagrams
- **Git**: If using git-based sync

## Monitoring & Observability

### Activity Log

Track vault changes:

```bash
# Git log
git log --pretty=format:"%h %ad | %s [%an]" --date=short

# File modification times
find . -type f -name "*.md" -mtime -7 -exec ls -lh {} \;
```

### Metrics to Track

- Notes created per week
- Active conversations (status: #open)
- Ideas in development (status: #evolving)
- Links shared

### Dashboard (Optional)

Create a vault note that uses Dataview to show metrics:

```markdown
# Vault Dashboard

## Active Conversations
\`\`\`dataview
TABLE status, participants
FROM "Conversations"
WHERE status = "open" OR status = "evolving"
SORT file.ctime DESC
\`\`\`

## Recent Ideas
\`\`\`dataview
TABLE originated-by, status, file.ctime as "Created"
FROM "Ideas"
SORT file.ctime DESC
LIMIT 10
\`\`\`

## Activity This Week
\`\`\`dataview
TABLE file.mtime as "Last Modified"
FROM ""
WHERE file.mtime >= date(today) - dur(7 days)
SORT file.mtime DESC
\`\`\`
```

## Security Checklist

- [ ] HTTPS enabled (TLS certificate)
- [ ] Authentication configured
- [ ] Network access restricted (VPN or IP allowlist)
- [ ] Backups automated
- [ ] Allowed signers list maintained
- [ ] Server hardened (firewall, SSH keys only, etc.)
- [ ] Monitoring/alerts set up
- [ ] Incident response plan (what if keys compromised?)

## Troubleshooting

### Can't connect to vault
- Check VPN connection
- Verify server is running: `systemctl status obsidian-web`
- Check firewall rules: `sudo ufw status`

### Authentication failing
- Verify wallet signature is from allowed address
- Check nonce isn't expired (implement timeout)
- Review server logs for error details

### Sync conflicts
- Use git to resolve: `git status`, `git diff`, merge manually
- Set up sync protocol to avoid (branch per person, merge periodically)

### Performance issues
- Check vault size (Obsidian can slow with >10k notes)
- Optimize Dataview queries (limit results)
- Increase server resources if needed

## Next Steps

1. Choose architecture (recommend Obsidian Web + VPN for MVP)
2. Deploy Obsidian Web instance
3. Implement authentication (crypto sign-in as committed)
4. Test access from both sides
5. Add automation integrations as needed
6. Monitor and iterate

---

**Questions? Issues?** Document them in [[Conversations/Vault Setup Discussion]]
