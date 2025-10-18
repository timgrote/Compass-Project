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

### 5. Share with Remote Collaborator (Tailscale Deployment)

**Recommended Approach**: Use Tailscale for secure, private access

#### Step 1: Get Your Tailscale IP

**On Windows** (if running Docker Desktop):
1. Open Tailscale app from system tray
2. Click on Tailscale icon - your IP shows (format: `100.x.x.x`)
3. **OR** open PowerShell: `tailscale ip -4`

**On Linux/WSL with Tailscale installed**:
```bash
tailscale ip -4
```

Example IP: `100.64.1.100`

#### Step 2: Choose Deployment Strategy

**Option A: Private Tailnet Access (Most Secure - Recommended)**

Hunter needs to join your Tailscale network:

1. **Invite Hunter to your tailnet**:
   - Go to https://login.tailscale.com/admin/machines
   - Click "Share" or "Add device"
   - Send Hunter the invite link

2. **Hunter installs Tailscale**:
   - Download from https://tailscale.com/download
   - Sign in using your invite link
   - Tailscale connects him to your network

3. **Share the URL with Hunter**:
   - Format: `http://YOUR_TAILSCALE_IP:3000`
   - Example: `http://100.64.1.100:3000`
   - He can only access it while connected to your tailnet

**Pros**:
- ✅ Encrypted peer-to-peer connection
- ✅ No public exposure
- ✅ Works from anywhere (Portugal, travel, etc.)
- ✅ Free for personal use (up to 100 devices)
- ✅ No port forwarding or firewall config needed

**Cons**:
- Hunter needs to install Tailscale
- Both need to be connected to tailnet

---

**Option B: Tailscale Funnel (Public HTTPS URL)**

Expose your vault publicly via Tailscale Funnel:

1. **Enable Funnel** (Windows PowerShell or Linux):
   ```powershell
   # Windows PowerShell
   tailscale funnel 3000

   # Linux/WSL
   sudo tailscale funnel 3000
   ```

2. **Get public URL**:
   - Format: `https://your-machine-name.your-tailnet.ts.net`
   - Example: `https://tim-windows.tailnet-123.ts.net`

3. **Share URL with Hunter**:
   - He can access from any browser
   - No Tailscale installation needed
   - Works from anywhere with internet

**Pros**:
- ✅ Hunter needs no setup - just click the link
- ✅ HTTPS automatically configured
- ✅ Works from anywhere

**Cons**:
- ⚠️ Publicly accessible (anyone with URL can access)
- ⚠️ Should add authentication (see Option 3A/3B below)
- ⚠️ Machine must stay running for access

---

**Option C: Local Network Only (Testing)**

For same-network testing only:

1. Get your Windows local IP:
   ```powershell
   ipconfig | findstr IPv4
   ```

2. Access from other device on same network:
   - Format: `http://YOUR_LOCAL_IP:3000`
   - Example: `http://192.168.1.100:3000`

**Limitation**: Only works when both on same WiFi/network

---

#### Recommended Setup for Hunter in Portugal

**Best approach**: **Option A (Private Tailnet)**

1. Send Hunter Tailscale invite
2. He installs Tailscale on his machine (Mac/Windows/Linux)
3. Share your Tailscale IP: `http://100.x.x.x:3000`
4. Both of you can access the vault from anywhere
5. Connection is encrypted and private

**When to use Funnel (Option B)**:
- Quick demo without Hunter installing anything
- You plan to add authentication (basic auth or crypto sign-in)
- You want a persistent public URL

#### Troubleshooting Tailscale

**Can't find Tailscale IP?**
- Check Tailscale is running (system tray icon)
- Open Tailscale admin console: https://login.tailscale.com/admin/machines
- Your machine's tailnet IP is listed there

**Hunter can't connect?**
- Verify he's signed into Tailscale and connected
- Check both machines show "Connected" in Tailscale
- Try pinging his Tailscale IP from yours: `ping 100.x.x.x`
- Ensure Docker port 3000 is accessible (should be by default)

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
