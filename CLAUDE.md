# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Compass** is a self-contained Docker deployment system that combines Obsidian vault management, n8n workflow automation, and AI integration (via MCP) to help people with depression, isolation, and lack of direction through structured journaling and reflection.

**Core Architecture:**
- Docker-based multi-container system (Obsidian REST API, n8n, PostgreSQL, MCP servers)
- Privacy-first design: runs completely locally, no required cloud services
- One-command installation target: `curl -sSL https://get.compass.ai/install.sh | bash`
- User vault data persists in Docker volumes, separate from application code

**Key Design Principles:**
- Progressive disclosure: simple initially, revealing complexity as users explore
- Low barrier to entry: works out-of-box with sensible defaults
- Maintainability: clear separation between user data and application code

## Repository Structure

This is the **deployment repository** (the installable product), not Tim's personal vault.

```
compass-deployment/
├── install.sh                     # One-command installer
├── docker-compose.yaml            # Base multi-container config
├── docker-compose.{dev,prod}.yaml # Environment overrides
├── .env.template                  # Environment variables template
│
├── config/                        # Configuration templates
│   ├── obsidian/vault-template/   # Starter Obsidian vault
│   ├── n8n/workflows/             # Pre-built automation workflows
│   └── mcp/servers/               # MCP server configurations
│
├── containers/                    # Custom Docker containers
│   ├── obsidian-api/              # Obsidian REST API container
│   ├── n8n/                       # n8n customizations
│   └── mcp-server/                # MCP server container
│
├── scripts/                       # Helper scripts
│   ├── first-run-setup.sh         # Interactive config wizard
│   ├── backup.sh                  # Backup user vault data
│   ├── restore.sh                 # Restore from backup
│   └── test-install.sh            # Validation for test machine
│
├── docs/                          # Documentation
│   ├── installation/              # Platform-specific install guides
│   ├── architecture/              # Technical architecture
│   └── troubleshooting/           # Common issues
│
└── tests/                         # Test scripts
    └── integration/               # Integration tests
```

## Development Commands

### Docker Operations

```bash
# Start all services
docker-compose up --build

# Start in detached mode
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f [service-name]

# Rebuild specific service
docker-compose build obsidian-api

# Remove volumes (WARNING: deletes user data)
docker-compose down -v
```

### Git Workflow

```bash
# Start new feature from develop
git checkout develop
git pull origin develop
git checkout -b feature/descriptive-name

# Commit with detailed messages
git commit -m "Add feature X

- Implemented Y
- Added Z
- Documented in docs/architecture/

Tested: [what was tested]
TODO: [remaining work]"

# Merge to develop when complete
git checkout develop
git merge feature/descriptive-name
git push origin develop

# Tag releases on main
git checkout main
git merge develop
git tag -a v0.1.0 -m "Phase 1: Basic Obsidian API"
git push origin main --tags
```

## Branch Strategy

- **`main`**: Production-ready releases only (protected, tagged with versions)
- **`develop`**: Integration branch for completed features
- **`documentation`**: Living documentation updates
- **`feature/*`**: New feature development (branch from develop)
- **`fix/*`**: Bug fixes
- **`test/*`**: Testing scenarios on separate machines

## Architecture Details

### Docker Services

**Network:** `compass-net` (bridge network for inter-container communication)

**Services:**

1. **`obsidian-api`** (Port 27124)
   - Custom container running Obsidian Local REST API
   - Mounts: `vault-data:/vault` (persistent), `./config/obsidian/vault-template:/vault-template:ro`
   - Provides REST API for vault read/write operations

2. **`n8n`** (Port 5678)
   - Workflow automation engine
   - Mounts: `n8n-data:/home/node/.n8n`, `./config/n8n/workflows:/workflows:ro`
   - Depends on: `postgres`, `obsidian-api`
   - Communicates with Obsidian via: `http://obsidian-api:27124/vault/`

3. **`postgres`**
   - Database for n8n state and workflows
   - Mounts: `postgres-data:/var/lib/postgresql/data`

4. **`mcp-server`** (Port 3000, Phase 4+)
   - AI assistant integration via Model Context Protocol
   - Depends on: `obsidian-api`

### Critical Volumes

```yaml
volumes:
  vault-data:      # User's Obsidian vault (CRITICAL - must backup)
  n8n-data:        # n8n workflows and execution history
  postgres-data:   # Database for n8n
```

### Networking

- **Internal:** Services communicate using container names as hostnames on `compass-net`
- **External:** Services exposed to localhost (or LAN if configured)
- **Security:** API keys generated on first run, basic auth on n8n

## Implementation Phases

### Phase 1: Obsidian REST API Proof of Concept
**Branch:** `feature/obsidian-api-basic`
- Get Obsidian REST API running in Docker
- Accessible from network
- Vault data persists across restarts
- Test from separate machine

### Phase 2: n8n Integration
**Branch:** `feature/n8n-basic-workflow`
- n8n communicates with Obsidian API
- Create daily journal entry workflow
- Test inter-container communication

### Phase 3: Installation Script
**Branch:** `feature/install-script`
- One-command installation on clean system
- Interactive setup wizard
- Test on clean WSL/separate machine

### Phase 4+: Future Features
- MCP Integration (AI-assisted reflections)
- Messaging Bots (Telegram/WhatsApp)
- Advanced features (pattern recognition, Telos framework)

## Development Workflow

### When Starting Work

1. Check current branch: `git status`
2. Verify which phase you're working on
3. This is the **deployment repo** (end-user product), not Tim's personal vault
4. Test changes locally before committing

### During Development

- Document discoveries as you go (update architecture docs)
- Commit frequently with clear messages
- Test with `docker-compose up --build` before pushing
- Update relevant documentation when design changes

### Testing Strategy

**Local (Machine 1):** Quick iteration on feature branches
**Integration (Machine 2):** Clean WSL instance simulating real user installation

**Test Scenarios:**
- All services start successfully
- Services communicate on internal network
- Vault data persists across restart
- Can create journal entry via API
- n8n workflow executes successfully
- Clear error messages for missing prerequisites

### Before Merging to Develop

- [ ] All tests passing
- [ ] Documentation updated
- [ ] No debug code or commented-out blocks
- [ ] `docker-compose up` works cleanly
- [ ] Feature-specific success criteria met

## Docker Best Practices

**Dockerfiles:**
- Use specific version tags (not `latest` in prod)
- Minimize layers (combine RUN commands)
- Clean up in same layer
- Document exposed ports and volumes

**docker-compose.yaml:**
- Use environment variables for configuration
- Mount volumes for data persistence
- Use health checks
- Set restart policies
- Document service dependencies

## Documentation Standards

**Code Comments:**
- Explain WHY, not just WHAT
- Link to relevant docs or issues
- Note any workarounds or hacks

**Architecture Docs (`docs/architecture/`):**
- Keep updated as design evolves
- Explain decisions and trade-offs
- Include diagrams where helpful

**User-Facing Docs:**
- Write for non-technical users
- Step-by-step instructions
- Troubleshooting sections

## Key Technology Decisions

**Docker:** Portability across Windows/Mac/Linux, isolation, reproducibility
**n8n:** Visual workflows, self-hosted, extensive integrations
**Obsidian:** Markdown-based, proven in Tim's daily use, mobile/desktop apps
**MCP:** Modern AI integration protocol, aligns with learning goals

## Reference Material

- **Obsidian Local REST API:** https://github.com/coddingtonbear/obsidian-local-rest-api
- **n8n Documentation:** https://docs.n8n.io/
- **Docker Compose:** https://docs.docker.com/compose/
- **Tim's project context:** `/mnt/d/Dropbox/Personal/Compass Project.md`

## Important Constraints

**Privacy-First:**
- Must run completely offline
- No required cloud services
- User data stays local
- Optional cloud integrations (user choice)

**Maintainability:**
- User data separated from application code
- Docker images can be updated independently
- Clear separation of concerns
- Well-documented architecture

## Developer Context

- **Primary developer:** Tim
- **Working directory:** `/mnt/d/repos/compass-deployment/`
- **Test machine:** Separate WSL instance
- **Familiar with:** .NET, n8n basics, Obsidian power user
- **Learning:** Docker, MCP, AI integration patterns
- **Mission:** Build systems that improve quality of life for all life on Earth

## Claude Code Configuration

### Permissions
This project uses `.claude/settings.local.json` for user-specific Claude Code permissions. Recommended permissions for this project:

```json
{
  "permissions": {
    "allow": [
      "Bash(git checkout:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(docker:*)",
      "Bash(docker-compose:*)"
    ]
  }
}
```

### Working with Future Claude Instances
- **This file (CLAUDE.md)** is your primary guidance document
- **README.md** contains comprehensive project documentation for users and developers
- Always check current branch and phase before starting work
- Use TodoWrite tool for multi-step tasks to track progress
- Test Docker changes locally before committing
