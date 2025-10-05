# Compass Deployment - Claude Instructions

**Date Created:** 2025-10-04
**Project:** Compass - AI-Assisted Personal Navigation System
**Developer:** Tim
**Context Source:** `/mnt/d/Dropbox/Personal/Compass Project.md`

---

## 🎯 Project Context

### What is Compass?

Compass is a packageable Obsidian vault + AI system to help people struggling with depression, isolation, and lack of direction. It transforms proven daily journaling and AI reflection systems into an accessible tool that gives people "someone to talk to" and helps them track their progress.

**Core Vision:**
- Self-contained Docker deployment (one command to install)
- Pre-configured Obsidian vault with journaling templates
- AI-assisted reflection and pattern recognition
- Messaging integration (Telegram/WhatsApp) for natural interaction
- Privacy-first: can run completely locally
- Progressive disclosure: simple texting → full journaling system

**Connected to Tim's Mission M1:**
"Build better systems that improve quality of life for all life on Earth"

### Why This Architecture?

**User Experience Goal:**
1. User installs WSL (Windows) or has Docker (Mac/Linux)
2. Runs: `curl -sSL https://get.compass.ai/install.sh | bash`
3. System self-configures and starts
4. User gets URL to access Obsidian vault
5. Optional: Install Obsidian mobile/desktop app and sync

**Technical Foundation:**
- Docker containers for portability and isolation
- n8n for workflow automation (already familiar to Tim)
- Obsidian for knowledge management (proven in Tim's personal use)
- MCP servers for AI integration (cutting-edge, aligns with Tim's AI learning)
- Message bots for low-friction user interaction

---

## 📁 Repository Structure

**This Repository:** `compass-deployment`
**Location:** `/mnt/d/repos/compass-deployment/` (NOT in Tim's personal vault)
**Purpose:** The installable product that end users will deploy

```
compass-deployment/
├── README.md                          # User-facing: "How to Install Compass"
├── README_FOR_CLAUDE.md              # This file - Claude's execution guide
├── ARCHITECTURE.md                    # Technical architecture documentation
├── CHANGELOG.md                       # Version history and updates
├── LICENSE                            # Open source license (TBD)
│
├── install.sh                         # One-command installer script
├── docker-compose.yaml                # Base multi-container configuration
├── docker-compose.dev.yaml           # Development overrides
├── docker-compose.prod.yaml          # Production overrides
├── .env.template                      # Environment variables template
├── .gitignore                         # Standard Docker/Node ignores
│
├── config/
│   ├── obsidian/
│   │   ├── vault-template/           # Blank Compass vault structure
│   │   │   ├── .obsidian/            # Obsidian app config
│   │   │   │   ├── plugins/          # Pre-installed plugins
│   │   │   │   │   ├── obsidian-local-rest-api/
│   │   │   │   │   └── templater-obsidian/
│   │   │   │   └── app.json          # Obsidian settings
│   │   │   ├── Templates/            # Journal templates
│   │   │   │   ├── Daily Journal.md
│   │   │   │   └── Weekly Review.md
│   │   │   ├── Journal/              # User's daily journals (empty initially)
│   │   │   ├── Telos.md              # Goal-setting framework template
│   │   │   └── Welcome to Compass.md # Getting started guide
│   │   └── plugins.json              # Plugin installation manifest
│   │
│   ├── n8n/
│   │   ├── workflows/                # Pre-built automation workflows
│   │   │   ├── daily-checkin.json
│   │   │   ├── weekly-review.json
│   │   │   └── telegram-bot.json
│   │   └── credentials.template.json # Credential structure (no secrets)
│   │
│   └── mcp/
│       ├── servers/                  # MCP server configurations
│       │   ├── obsidian-mcp/
│       │   └── anthropic-mcp/
│       └── config.json               # MCP server routing
│
├── containers/
│   ├── obsidian-api/                 # Custom Obsidian REST API container
│   │   ├── Dockerfile
│   │   ├── entrypoint.sh
│   │   └── healthcheck.sh
│   │
│   ├── n8n/                          # n8n container customizations
│   │   ├── Dockerfile                # Extended n8n image
│   │   └── init-workflows.sh
│   │
│   └── mcp-server/                   # MCP server container
│       ├── Dockerfile
│       └── server.js
│
├── scripts/
│   ├── first-run-setup.sh            # Interactive configuration wizard
│   ├── configure.sh                  # Reconfigure after installation
│   ├── backup.sh                     # Backup user vault data
│   ├── restore.sh                    # Restore from backup
│   ├── update.sh                     # Update containers to latest versions
│   ├── uninstall.sh                  # Clean removal
│   └── test-install.sh               # Validation script for test machine
│
├── docs/
│   ├── installation/
│   │   ├── windows-wsl.md
│   │   ├── macos.md
│   │   └── linux.md
│   ├── architecture/
│   │   ├── overview.md
│   │   ├── networking.md
│   │   ├── data-persistence.md
│   │   └── security.md
│   ├── development/
│   │   ├── local-setup.md
│   │   ├── testing.md
│   │   └── contributing.md
│   └── troubleshooting/
│       ├── common-issues.md
│       └── network-problems.md
│
└── tests/
    ├── integration/
    │   ├── test-vault-creation.sh
    │   ├── test-n8n-connection.sh
    │   └── test-api-access.sh
    └── unit/
        └── (future: component-specific tests)
```

---

## 🔀 GitHub Branch Strategy

### Main Branches

**`main`**
- Stable, production-ready releases only
- Protected branch (no direct commits)
- Tagged with version numbers (v0.1.0, v0.2.0, etc.)
- What end users will clone/install

**`develop`**
- Integration branch for completed features
- Features merge here for testing together
- Merges to `main` for releases
- Always in a "should work" state

**`documentation`**
- Living documentation updates
- Merges frequently to `develop`
- For architecture docs, guides, troubleshooting

### Feature Branches (Tim's Development)

**Naming Convention:** `feature/descriptive-name`

**Planned Feature Branches:**

1. **`feature/obsidian-api-basic`** (Phase 1 - Start Here!)
   - Get Obsidian REST API running in Docker
   - Mount a test vault
   - Document network access from another machine
   - **Goal:** Can read/write vault programmatically

2. **`feature/n8n-basic-workflow`** (Phase 2)
   - Add n8n container
   - Create one simple workflow (daily prompt via webhook)
   - Test inter-container communication
   - **Goal:** n8n can write to Obsidian vault via API

3. **`feature/install-script`** (Phase 3)
   - Write install.sh that works on clean WSL
   - Test on separate machine
   - Iterate based on pain points
   - **Goal:** Someone else could install this

4. **`feature/mcp-integration`** (Phase 4)
   - MCP server container
   - Claude/AI integration
   - **Goal:** AI can interact with vault

5. **`feature/telegram-bot`** (Phase 5)
   - Telegram webhook handler
   - Message → vault entry workflow
   - **Goal:** Text a bot, it updates your journal

6. **`feature/vault-template`** (Ongoing)
   - Refine journal templates
   - Add helpful starting content
   - **Goal:** New user has clear path forward

**Test Branch:**

**`test/separate-machine`**
- Document actual installation experience
- Track issues found during testing
- Network configuration discoveries
- Merge findings back to relevant feature branches

### Workflow Process

```
1. Create feature branch from develop
   git checkout develop
   git pull origin develop
   git checkout -b feature/obsidian-api-basic

2. Build and document feature
   - Make changes
   - Test locally
   - Commit with detailed messages
   - Update relevant docs

3. Push and test on separate machine
   git push origin feature/obsidian-api-basic
   # On test machine: git pull, test installation

4. Merge to develop when working
   git checkout develop
   git merge feature/obsidian-api-basic
   git push origin develop

5. Tag release when ready
   git checkout main
   git merge develop
   git tag -a v0.1.0 -m "Phase 1: Basic Obsidian API"
   git push origin main --tags
```

---

## 🏗️ Technical Architecture

### Docker Services Stack

**Network:** `compass-net` (bridge network for inter-container communication)

**Services:**

1. **`obsidian-api`**
   - **Image:** Custom (build from `containers/obsidian-api/`)
   - **Purpose:** Obsidian Local REST API server
   - **Exposes:** Port 27124 (REST API)
   - **Volumes:**
     - `vault-data:/vault` (persistent user vault)
     - `./config/obsidian/vault-template:/vault-template:ro` (initial template)
   - **Environment:**
     - `VAULT_PATH=/vault`
     - `API_KEY=<generated-on-first-run>`

2. **`n8n`**
   - **Image:** `n8nio/n8n:latest` (or custom extended)
   - **Purpose:** Workflow automation engine
   - **Exposes:** Port 5678 (web UI)
   - **Volumes:**
     - `n8n-data:/home/node/.n8n`
     - `./config/n8n/workflows:/workflows:ro` (pre-built workflows)
   - **Environment:**
     - `N8N_BASIC_AUTH_ACTIVE=true`
     - `N8N_BASIC_AUTH_USER=<user-configured>`
     - `N8N_BASIC_AUTH_PASSWORD=<user-configured>`
     - `WEBHOOK_URL=<external-url-if-configured>`
   - **Depends on:** `postgres`, `obsidian-api`

3. **`postgres`**
   - **Image:** `postgres:15-alpine`
   - **Purpose:** Database for n8n state and workflows
   - **Volumes:** `postgres-data:/var/lib/postgresql/data`
   - **Environment:**
     - `POSTGRES_DB=n8n`
     - `POSTGRES_USER=n8n`
     - `POSTGRES_PASSWORD=<generated-on-first-run>`

4. **`mcp-server`** (Optional, Phase 4+)
   - **Image:** Custom (build from `containers/mcp-server/`)
   - **Purpose:** AI assistant integration via Model Context Protocol
   - **Exposes:** Port 3000 (MCP protocol)
   - **Depends on:** `obsidian-api`

5. **`web-ui`** (Future consideration)
   - **Purpose:** Browser-based vault viewer (if not using Obsidian app)
   - **Alternative:** Could use Obsidian Publish or simple markdown viewer

### Data Persistence

**Docker Volumes:**

```yaml
volumes:
  vault-data:      # User's Obsidian vault (CRITICAL - must backup)
  n8n-data:        # n8n workflows and execution history
  postgres-data:   # Database for n8n
```

**Backup Strategy:**
- `scripts/backup.sh` creates timestamped archives
- Backs up all three volumes
- Stores in `~/compass-backups/` by default
- User can configure cloud sync (Dropbox, etc.)

### Networking

**Internal (Container-to-Container):**
- All services on `compass-net` bridge network
- Services use container names as hostnames
- Example: n8n calls `http://obsidian-api:27124/vault/`

**External Access:**
- `obsidian-api`: localhost:27124 (or LAN IP if configured)
- `n8n`: localhost:5678 (or LAN IP if configured)
- Optional: Ngrok/Tailscale tunnel for mobile access

**Security Considerations:**
- API keys generated on first run
- Basic auth on n8n
- Option to bind only to localhost (most secure)
- Option to expose to LAN with authentication
- Future: HTTPS with Let's Encrypt for public access

---

## 🚀 Phase-by-Phase Implementation Plan

### Phase 1: Obsidian REST API Proof of Concept
**Branch:** `feature/obsidian-api-basic`
**Goal:** Get Obsidian REST API running in Docker, accessible from network

**Steps:**

1. **Research Obsidian Docker options**
   - Can Obsidian run headless in Docker?
   - Or do we just mount vault files + separate API server?
   - Check: https://github.com/coddingtonbear/obsidian-local-rest-api

2. **Create base Dockerfile**
   ```dockerfile
   # containers/obsidian-api/Dockerfile
   # Base: Node.js or appropriate runtime
   # Install Obsidian Local REST API plugin standalone
   # Or install full Obsidian + plugin
   ```

3. **Create minimal vault template**
   ```
   config/obsidian/vault-template/
   ├── .obsidian/
   │   └── plugins/
   │       └── obsidian-local-rest-api/
   ├── Welcome.md
   └── Journal/
       └── .gitkeep
   ```

4. **Write docker-compose.yaml (minimal)**
   ```yaml
   services:
     obsidian-api:
       build: ./containers/obsidian-api
       ports:
         - "27124:27124"
       volumes:
         - vault-data:/vault
         - ./config/obsidian/vault-template:/vault-template:ro
       networks:
         - compass-net

   volumes:
     vault-data:

   networks:
     compass-net:
   ```

5. **Test locally**
   ```bash
   docker-compose up --build
   curl http://localhost:27124/  # Should get API response
   ```

6. **Test from separate machine**
   - Document network setup (firewall rules, IP addressing)
   - Test read/write operations
   - Document any issues in branch README

7. **Document in `docs/architecture/obsidian-api.md`**
   - How it works
   - API endpoints available
   - Configuration options

**Success Criteria:**
- [ ] Obsidian API responds to requests
- [ ] Can create/read/update vault files via API
- [ ] Accessible from test machine on same network
- [ ] Vault data persists across container restarts

---

### Phase 2: n8n Integration
**Branch:** `feature/n8n-basic-workflow`
**Goal:** n8n can communicate with Obsidian API and create journal entries

**Steps:**

1. **Add n8n to docker-compose.yaml**
   ```yaml
   services:
     postgres:
       # Add postgres for n8n

     n8n:
       image: n8nio/n8n:latest
       depends_on:
         - postgres
         - obsidian-api
       # ... configuration
   ```

2. **Create simple workflow**
   - Trigger: Webhook (POST request)
   - Action: Create daily journal entry in Obsidian
   - Test: `curl -X POST http://localhost:5678/webhook/test`

3. **Export workflow to config**
   ```bash
   # Export from n8n UI
   # Save to config/n8n/workflows/daily-journal.json
   ```

4. **Test inter-container communication**
   - n8n → Obsidian API (http://obsidian-api:27124)
   - Verify network connectivity
   - Handle errors gracefully

5. **Document workflow structure**
   - What triggers are available
   - How to add new workflows
   - How to import pre-built workflows

**Success Criteria:**
- [ ] n8n starts and connects to postgres
- [ ] Can access n8n UI from browser
- [ ] Workflow can call Obsidian API successfully
- [ ] Can create journal entry via webhook
- [ ] Workflow configuration is exportable/importable

---

### Phase 3: Installation Script
**Branch:** `feature/install-script`
**Goal:** One-command installation on clean system

**Steps:**

1. **Write `install.sh`**
   ```bash
   #!/bin/bash
   # Check prerequisites (Docker, Docker Compose, WSL version)
   # Create directory structure
   # Copy .env.template to .env
   # Generate secure passwords/API keys
   # Pull/build Docker images
   # Initialize vault from template
   # Start services
   # Display access URLs and credentials
   ```

2. **Write `first-run-setup.sh`** (interactive wizard)
   ```bash
   # Ask user for:
   # - Name (personalize templates)
   # - Timezone
   # - Access preferences (localhost/LAN/public)
   # - Optional: Messaging platform setup
   # - Optional: AI API keys
   # Update .env with choices
   # Restart services with new config
   ```

3. **Test on clean WSL instance** (separate machine or VM)
   ```bash
   # Fresh WSL install
   # Run: curl -sSL https://raw.githubusercontent.com/.../install.sh | bash
   # Document every step, every error
   # Fix issues, push updates
   # Test again
   ```

4. **Write uninstall script**
   ```bash
   # scripts/uninstall.sh
   # Stop containers
   # Optionally backup data
   # Remove volumes (with confirmation!)
   # Clean up files
   ```

5. **Create user README.md**
   - Installation instructions
   - First-time setup
   - How to access your vault
   - Troubleshooting common issues

**Success Criteria:**
- [ ] Clean system → working Compass in under 5 minutes
- [ ] All prerequisites are checked before proceeding
- [ ] Errors are clear and actionable
- [ ] User knows how to access their vault after install
- [ ] Tested successfully on separate machine

---

### Phase 4+: Future Features

**Phase 4: MCP Integration**
- Add MCP server container
- Connect Claude/AI to vault
- AI-assisted journal reflections

**Phase 5: Messaging Bots**
- Telegram/WhatsApp webhook handlers
- Text → journal entry automation
- Daily prompts via messaging

**Phase 6: Advanced Features**
- Weekly/monthly review automation
- Pattern recognition and insights
- Telos framework integration
- Mood tracking and visualization

**Phase 7: Polish & Distribution**
- Pre-built Docker images on Docker Hub
- One-line install command
- Website with documentation
- Video tutorials

---

## 🧪 Testing Strategy

### Local Development Testing (Machine 1)

**Environment:** Tim's current WSL setup at `/mnt/d/repos/compass-deployment`

**Process:**
1. Make changes on feature branch
2. Test with `docker-compose up --build`
3. Verify functionality locally
4. Commit and push to GitHub

**Quick iteration:**
```bash
docker-compose down
# Make changes
docker-compose up --build
# Test
```

### Integration Testing (Machine 2)

**Environment:** Clean WSL instance on separate physical machine

**Purpose:**
- Simulate real user installation experience
- Validate network setup documentation
- Find gaps in instructions
- Test cross-machine connectivity

**Process:**
1. On Machine 2: `git clone` the repo
2. Follow installation instructions exactly as user would
3. Document every issue, confusion, or error
4. Push findings to `test/separate-machine` branch
5. Fix issues on Machine 1
6. Retest on Machine 2

### Test Scenarios

**Basic Functionality:**
- [ ] Install completes without errors
- [ ] All services start successfully
- [ ] Can access n8n UI from browser
- [ ] Can access Obsidian API
- [ ] Vault data persists across restart
- [ ] Can create journal entry via API
- [ ] n8n workflow executes successfully

**Network Testing:**
- [ ] Services communicate on internal network
- [ ] Can access from host machine (localhost)
- [ ] Can access from same LAN (other machines)
- [ ] Firewall rules documented
- [ ] API authentication works

**Data Integrity:**
- [ ] Vault data survives container restart
- [ ] Backup script creates valid archives
- [ ] Restore script recovers data correctly
- [ ] No data loss during updates

**Error Handling:**
- [ ] Clear error messages for missing prerequisites
- [ ] Graceful handling of port conflicts
- [ ] Recovery from failed containers
- [ ] Helpful troubleshooting guidance

---

## 💡 Key Decisions & Constraints

### Why Docker?
- **Portability:** Works on Windows (WSL), Mac, Linux
- **Isolation:** Doesn't mess with user's system
- **Reproducibility:** Same environment everywhere
- **Easy updates:** Pull new images, restart
- **Learning opportunity:** Tim wants to learn Docker containerization

### Why n8n?
- **Visual workflows:** Easy to understand and modify
- **Self-hosted:** Privacy and control
- **Extensive integrations:** Telegram, APIs, databases, etc.
- **Familiar to Tim:** Already studying n8n

### Why Obsidian?
- **Proven:** Tim uses it daily successfully
- **Markdown-based:** Universal, future-proof format
- **Plugin ecosystem:** Extensible functionality
- **Mobile/desktop apps:** Official apps for all platforms
- **Offline-first:** Works without internet

### Why MCP?
- **Cutting-edge:** Modern AI integration protocol
- **Standardized:** Claude, other AIs can use it
- **Flexible:** Can add multiple MCP servers for different functions
- **Learning opportunity:** Aligns with Tim's AI exploration

### Design Constraints

**Privacy-First:**
- Must be able to run completely offline
- No required cloud services
- User data stays on user's machine
- Optional cloud integrations (user choice)

**Progressive Disclosure:**
- Start simple (just text a bot)
- Reveal complexity as user explores
- Don't overwhelm newcomers
- Power users can access full system

**Low Barrier to Entry:**
- One command to install
- Works out of box with defaults
- Configuration is optional, not required
- Clear, jargon-free instructions

**Maintainability:**
- Docker images can be updated independently
- User data separated from application code
- Clear separation of concerns
- Well-documented architecture

---

## 🛠️ Execution Instructions for Claude

### When Tim Opens You in the New Repo

**1. Orient Yourself**
```bash
pwd  # Should be /mnt/d/repos/compass-deployment
git status  # Check current branch
git branch -a  # See all branches
```

**2. Check Current Phase**
- Read git branch name
- Check this document for phase details
- Ask Tim: "Which phase are we working on?"

**3. Understand the Context**
- This is NOT Tim's personal vault
- This is the deployment repository (the product)
- Changes here will be used by end users
- Test changes before committing

**4. Development Workflow**

**Starting a new feature:**
```bash
git checkout develop
git pull origin develop
git checkout -b feature/name-of-feature
# Update this README with progress notes
# Create feature-specific README in branch
```

**During development:**
- Document discoveries as you go
- Update architecture docs when design changes
- Commit frequently with clear messages
- Test locally before pushing

**Example commit message:**
```
Add Obsidian REST API Docker container

- Created Dockerfile for obsidian-api service
- Implemented vault initialization from template
- Added healthcheck endpoint
- Documented API endpoints in docs/architecture/

Tested: API responds on localhost:27124
TODO: Test from separate machine (network access)
```

**Testing on separate machine:**
```bash
git push origin feature/obsidian-api-basic
# Tim will test on Machine 2
# Document findings in test/separate-machine branch
# Merge fixes back to feature branch
```

**5. Communication with Tim**

**When you need decisions:**
- "I found two approaches for X. Option A does [...], Option B does [...]. Which direction do you prefer?"
- Present trade-offs clearly
- Recommend based on project goals

**When you're stuck:**
- "I'm blocked on X because of Y. I've tried [...]. Need your input on how to proceed."
- Show what you've attempted
- Suggest potential paths forward

**When you complete a milestone:**
- "Completed Phase 1: Obsidian API is working. Successfully tested: [checklist]. Ready to merge to develop?"
- Summarize what works
- Note any issues or limitations
- Ask about next steps

**6. Documentation Standards**

**Code comments:**
- Explain WHY, not just WHAT
- Link to relevant docs or issues
- Note any workarounds or hacks

**Architecture docs:**
- Keep updated as design evolves
- Include diagrams where helpful (mermaid.js syntax)
- Explain decisions and trade-offs

**User-facing docs:**
- Write for non-technical users
- Step-by-step instructions
- Screenshots where helpful
- Troubleshooting section

**This README:**
- Update progress as phases complete
- Add lessons learned
- Note deviations from plan
- Keep it as source of truth

**7. Git Hygiene**

**Branch naming:**
- `feature/descriptive-name` for new features
- `fix/issue-description` for bug fixes
- `docs/topic` for documentation updates
- `test/scenario` for testing branches

**Commit frequency:**
- Commit working states, not broken code
- One logical change per commit
- Can commit frequently (better than losing work)
- Can squash before merging if needed

**Before merging to develop:**
- All tests passing
- Documentation updated
- No debug code or commented-out blocks
- `docker-compose up` works cleanly

**8. File Operations**

**When creating new files:**
- Check directory structure in this README
- Put files in correct locations
- Update .gitignore if needed
- Add explanatory comments

**When editing config:**
- Preserve comments and structure
- Add comments for any non-obvious settings
- Update .env.template if needed
- Document changes in relevant docs

**9. Docker Best Practices**

**Dockerfiles:**
- Use specific version tags (not `latest` in prod)
- Minimize layers (combine RUN commands)
- Clean up in same layer (rm after install)
- Use .dockerignore
- Document exposed ports and volumes

**docker-compose.yaml:**
- Use environment variables for config
- Mount volumes for persistence
- Use health checks
- Set restart policies
- Document service dependencies

**10. Asking for Web Resources**

**When you need external docs:**
- "I need to check the latest Docker Compose syntax. May I fetch https://docs.docker.com/compose/...?"
- Be specific about what you're looking for
- Summarize findings after fetching

**When you find useful resources:**
- Save to appropriate docs/ folder
- Summarize key points in architecture docs
- Note source URL for future reference

---

## 📚 Reference Material

### Local Documentation
- **Compass Project context:** `/mnt/d/Dropbox/Personal/Compass Project.md`
- **Docker overview:** `/mnt/d/Dropbox/Personal/Docs/docker/Docker-MCP-Overview.md`
- **Tim's personal vault:** `/mnt/d/Dropbox/Personal/` (for inspiration, not copying)

### External Resources
- **Docker Compose docs:** https://docs.docker.com/compose/
- **n8n documentation:** https://docs.n8n.io/
- **Obsidian API:** https://github.com/coddingtonbear/obsidian-local-rest-api
- **MCP Protocol:** https://github.com/anthropics/mcp (or check Tim's Claude docs)

### Tim's Development Context
- **Working directory:** `/mnt/d/repos/compass-deployment/`
- **Test machine:** Separate WSL instance (details TBD)
- **Familiar with:** .NET, n8n basics, Obsidian power user
- **Learning:** Docker, MCP, AI integration patterns

---

## 🎯 Success Metrics

### Phase 1 Success:
- Obsidian REST API container runs reliably
- Can read/write vault via API from network
- Vault data persists across restarts
- Documented network setup works on test machine

### Phase 2 Success:
- n8n can trigger Obsidian API calls
- Daily journal entry workflow works
- Inter-container communication reliable
- Workflows are exportable/importable

### Phase 3 Success:
- Non-technical user can install Compass
- Installation takes < 5 minutes
- Clear instructions with no ambiguity
- Tested successfully by someone other than Tim

### Overall Project Success:
- Helps at least one person (like Kurt) find direction
- Positive user feedback on ease of use
- System runs reliably for 30+ days
- Tim learns Docker, MCP, and deployment practices
- Foundation for future features (messaging, AI, etc.)

---

## 🔄 Version History

**v0.0.1** - 2025-10-04
- Initial planning session with Claude
- Repository structure defined
- Phase 1-3 implementation plan created
- This README created

**Next version:** TBD when Phase 1 completes

---

## 📝 Notes & Observations

### Things to Explore
- Can Obsidian run headless in Docker? Or just vault + separate API?
- Best way to handle Obsidian plugin installation in container
- Network security implications of exposing services to LAN
- Backup strategy for users who aren't technical
- How to handle Obsidian app syncing with Docker vault

### Open Questions
- Should we build custom Obsidian container or use existing?
- Pre-built images on Docker Hub vs. build-from-source?
- How to handle updates without disrupting user data?
- What's the minimal web interface if user doesn't want Obsidian app?
- How to make AI features optional but easy to enable?

### Lessons Learned
*(Update as we build)*

---

**Remember:** This is Tim's learning project AND a tool to help people. Balance between:
- Learning new technologies (Docker, MCP)
- Shipping something that works
- Helping people who are struggling
- Building sustainably (not a fragile hack)

**When in doubt, ask Tim!**

---

*End of README_FOR_CLAUDE.md*
