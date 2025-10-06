# Session Notes: Obsidian Configuration Workflow
**Date:** 2025-10-05
**Phase:** Phase 1 - Obsidian REST API Setup

## What We Accomplished Tonight

### 1. Created Sanitized Vault Template
- Moved `vault-template/` → `compass-vault/`
- Added Obsidian configuration to auto-open "Welcome to Compass.md"
- Files: Welcome to Compass.md, Telos.md, Daily Journal template
- Content is generic and appropriate for end users

### 2. Implemented Auto-Initialization
- Created `scripts/init-vault.sh`
- Automatically copies vault template on container first run
- Creates `obsidian.json` to auto-open Compass vault
- No more vault picker - goes straight to the vault!

### 3. Commits Created
```
691f311 Add sanitized Compass vault template with Obsidian config
c69b249 Add automatic vault initialization on container startup
```

## IMPORTANT: Obsidian Configuration Workflow

### How to Configure Obsidian

**YES - You can configure Obsidian through the web interface at http://localhost:3000**

Things you can do:
- Install plugins (including REST API plugin!)
- Configure settings
- Customize themes
- Create templates
- Set up hotkeys

### Where Configuration is Stored

**Inside the container:**
- Path: `/config/Compass/.obsidian/`
- Volume: `vault-data` (persists across restarts)

**Persistence:**
- ✅ Survives container restarts
- ✅ Survives `docker-compose down` and `up`
- ❌ Lost if you run `docker-compose down -v` (deletes volumes)

### How to Pull Changes into Docker Setup

**Method 1: Extract from Running Container (recommended)**
```bash
# Copy the .obsidian directory from container to template
docker cp compass-obsidian:/config/Compass/.obsidian ./config/obsidian/compass-vault/.obsidian

# Then commit the changes
git add config/obsidian/compass-vault/.obsidian
git commit -m "Update vault template with configured plugins"
```

**Method 2: Manual Workflow (current approach)**
1. Configure Obsidian via web UI (http://localhost:3000)
2. When satisfied with setup, run the `docker cp` command above
3. Review the extracted files
4. Commit to git
5. Future deployments will have your configuration baked in

### Next Steps (TODO for next session)

**Priority 1: Install REST API Plugin**
1. Open Obsidian web UI
2. Go to Settings → Community Plugins
3. Browse and install "Local REST API"
4. Configure API settings (port 27124, authentication, etc.)
5. Extract the config with `docker cp`
6. Commit to repository

**Priority 2: Test REST API**
- Verify API is accessible from outside container
- Test basic operations (read notes, create notes)
- Document API endpoints for n8n integration (Phase 2)

**Priority 3: Document the Workflow**
- Add to README.md or create docs/configuration-management.md
- Explain how developers can update the vault template
- Document backup/restore procedures

## Technical Notes

### Why This Works
- Obsidian reads `obsidian.json` on startup to know which vault(s) to open
- The `"open": true` flag tells it to auto-open that vault
- User changes to `.obsidian/` directory persist in the `vault-data` volume
- Template in `compass-vault/` is read-only (mounted with `:ro` flag)
- Actual vault lives in `/config/Compass` (read-write, persists)

### Init Script Behavior
- Only creates `obsidian.json` if it doesn't exist
- This means user can switch vaults later without interference
- Vault directory always gets copied on first run
- Idempotent - safe to run multiple times

### File Paths Reference
```
Host:                                 Container:
./config/obsidian/compass-vault/   →  /vault-template (read-only)
vault-data volume                  →  /config (persistent)
                                      /config/Compass (actual vault)
                                      /config/.config/obsidian/obsidian.json (vault config)
./scripts/init-vault.sh           →  /etc/cont-init.d/99-init-vault (read-only)
```

## Questions to Consider

1. **Plugin Management**: Should we pre-install REST API plugin in template, or let users install it?
   - Pro (pre-install): Works out of box
   - Con (pre-install): Might include API key in git (security issue)
   - **Recommendation**: Document installation steps, don't pre-install with keys

2. **Configuration Versioning**: How do we handle config updates?
   - Option A: Users manually extract and PR their configs
   - Option B: Create `scripts/export-config.sh` helper
   - **Recommendation**: Create helper script in Phase 2

3. **Testing Clean Installs**: How to test that template works for new users?
   - Delete volume: `docker-compose down -v`
   - Restart: `docker-compose up -d`
   - Verify vault auto-opens with correct content

## Session End Status

- ✅ Vault template sanitized and working
- ✅ Auto-initialization working perfectly
- ✅ Changes committed with detailed messages
- ⏭️ Next: Install and configure REST API plugin
- ⏭️ Then: Test API accessibility from host machine

**Container Status:** Running, accessible at http://localhost:3000
**Branch:** feature/obsidian-api-basic
**Ready for:** REST API plugin installation and testing
