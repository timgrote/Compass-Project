# Conversation Vault Deployment Test

Quick guide to test the conversation vault deployment.

## Current Status

**Branch**: `feature/conversation-vault`
**Changes**: Replaced personal journaling vault with collaborative conversation vault

## What Changed

1. **Vault Template**: Swapped out Telos/journaling vault for conversation vault
2. **Structure**: Now has Conversations, Ideas, Links, Tim-Notes, Hunter-Notes
3. **Templates**: Templater templates for creating conversations, ideas, links, etc.
4. **Examples**: Sample content showing conversation patterns with Hunter

## Quick Test Deployment

### 1. Deploy Locally

```bash
cd /mnt/d/repos/Compass-Project
git checkout feature/conversation-vault
docker compose up -d
```

### 2. Access the Vault

Open http://localhost:3000 in your browser

You should see:
- Conversation vault with folders for Conversations, Ideas, Links, etc.
- Example conversation about AI Agent Communication
- Example idea about Semantic Search
- Sample weekly updates for Tim and Hunter
- README explaining how to use the vault

### 3. Test the Vault

**Navigate**:
- Check out `/Conversations/Example - AI Agent Communication.md`
- Review `/Ideas/Example - Semantic Search for PKM.md`
- Read `/Setup/Deployment Guide.md` for architecture options

**Create Content**:
- Try creating a new conversation using the template in `/.templates/Conversation.md`
- Test creating an idea
- Add a link with dual analysis sections

**Verify**:
- Templates work (Templater plugin should be available)
- Links between notes work
- Graph view shows connections
- Can read and write notes

### 4. Check Docker Services

```bash
# View logs
docker compose logs -f obsidian

# Check all services are running
docker compose ps

# Should see: obsidian, n8n, postgres all healthy
```

### 5. Test from Another Device (Optional)

If you want to test remote access:

**Option A: Local Network**
- Get your machine's local IP: `ip addr show`
- Access from another device: `http://YOUR_IP:3000`

**Option B: VPN (Tailscale recommended)**
- Install Tailscale on host machine
- Share Tailscale IP with Hunter
- Access via Tailscale IP: `http://TAILSCALE_IP:3000`

## Next Steps: Adding Authentication

Once basic deployment works, we can add auth layer (Option 3 from discussion):

### Option 3A: Basic Auth (Quick)

Add nginx reverse proxy with basic auth:

```yaml
# Add to docker-compose.yaml
nginx:
  image: nginx:alpine
  ports:
    - "80:80"
  volumes:
    - ./config/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - ./config/nginx/.htpasswd:/etc/nginx/.htpasswd:ro
  depends_on:
    - obsidian
```

Create `.htpasswd`:
```bash
htpasswd -c config/nginx/.htpasswd tim
htpasswd config/nginx/.htpasswd hunter
```

### Option 3B: Crypto Sign-In (As Committed to Hunter)

Add Web3 authentication layer:
- Frontend: MetaMask/WalletConnect integration
- Backend: Verify signatures against allowed addresses
- Store allowlist: Tim's address, Hunter's address

See `/Setup/Deployment Guide.md` in the vault for full crypto auth architecture.

## Rollback if Needed

If you want to go back to the original Compass vault:

```bash
cd /mnt/d/repos/Compass-Project
rm -rf config/obsidian/compass-vault
mv config/obsidian/compass-vault.backup config/obsidian/compass-vault
git checkout main
docker compose up -d
```

## Sharing with Hunter

Once tested and working:

1. **Deploy on your server** (or keep running locally)
2. **Set up access** (VPN or expose with auth)
3. **Share the URL** with Hunter
4. **Point him to the README** in the vault for usage guide

The vault itself contains all the documentation he needs in:
- `/README.md` - How to use the vault
- `/Setup/Deployment Guide.md` - Technical setup details
- `/Setup/Template Usage.md` - How to use Templater templates

## Feedback & Iteration

After you and Hunter use it for a bit:
- See what works, what doesn't
- Adjust templates as needed
- Add automation (Telegram integration, etc.)
- Consider authentication if remote access needed

---

**Questions or issues?** Document them in a new conversation in the vault itself!
