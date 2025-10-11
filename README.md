# Compass 🧭

**AI-Assisted Personal Navigation System**

A privacy-first journaling and reflection system to help you find direction in life.

## Quick Start

### Prerequisites

- Docker Desktop (Windows/Mac) or Docker + Docker Compose (Linux)

### Installation

```bash
# Clone the repository
git clone https://github.com/timgrote/Compass-Project.git
cd Compass-Project

# Start Compass
docker compose up -d
```

### Access Compass

**Obsidian Vault:** http://localhost:3000
Your personal vault for journaling and notes.

**n8n Workflow Automation:** http://localhost:5678
Create automated workflows to interact with your vault.

## What's Inside

- 📓 Pre-configured Obsidian vault with journaling templates
- 🤖 n8n workflow automation for scheduled journaling
- 🎯 Telos framework for goal-setting and purpose
- 🔒 Runs completely locally - your data stays private

## Common Commands

```bash
# Stop Compass
docker compose down

# Restart Compass
docker compose restart

# View logs
docker compose logs -f
```

## Learn More

- **n8n Setup Guide:** [docs/n8n-setup-guide.md](docs/n8n-setup-guide.md) - Configure workflows and automation
- **Developer Guide:** [DEVELOPER-GUIDE.md](DEVELOPER-GUIDE.md) - Full feature list, roadmap, and management
- **Claude Code Guide:** [CLAUDE.md](CLAUDE.md) - For AI-assisted development
- **Architecture:** [docs/architecture/](docs/architecture/) - Technical documentation

---

**Status:** Phase 2 (n8n Integration) Complete | **License:** TBD
