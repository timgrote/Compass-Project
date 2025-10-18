# Compass 🧭

**Collaborative Conversation Vault**

A privacy-first shared Obsidian vault for async conversation and collaborative idea development.

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
Shared vault for conversations, ideas, and collaboration.

**n8n Workflow Automation:** http://localhost:5678
Create automated workflows to interact with your vault.

## What's Inside

- 💬 Pre-configured conversation vault with threaded discussions
- 💡 Shared idea development space with collaboration patterns
- 🔗 Link library with dual analysis sections
- 📝 Personal spaces for each person (read-only for others)
- 🤖 n8n workflow automation ready for Telegram/voice integration
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
