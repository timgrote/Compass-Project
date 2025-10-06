# Developer Guide

## What You Get

- 📓 **Obsidian Vault:** Pre-configured journaling system with templates
- 🎯 **Telos Framework:** Goal-setting and reflection structure
- 🤖 **AI Integration:** (Coming soon) Intelligent insights and pattern recognition
- 📱 **Messaging Integration:** (Coming soon) Journal via text message
- 🔒 **Privacy-First:** Runs completely locally, no cloud required

## Managing Your System

```bash
# View logs
docker compose logs -f obsidian

# Stop Compass
docker compose down

# Restart Compass
docker compose restart

# Update to latest version
git pull
docker compose pull
docker compose up -d
```

## Backup Your Data

Your journal entries are stored in a Docker volume. To backup:

```bash
# Create backup (coming soon: scripts/backup.sh)
docker run --rm \
  -v compass-project_vault-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/vault-backup-$(date +%Y%m%d).tar.gz /data
```

## Development Roadmap

**Phase 1:** ✅ Obsidian + REST API (In Development)
- Docker-based Obsidian deployment
- Web-accessible vault
- REST API for programmatic access

**Phase 2:** ⏳ n8n Workflow Automation (Planned)
- Automated daily prompts
- Workflow triggers

**Phase 3:** ⏳ Easy Installation (Planned)
- One-command install script
- Interactive setup wizard

**Phase 4:** ⏳ AI Integration (Planned)
- Claude integration via MCP
- Intelligent reflections

**Phase 5:** ⏳ Tailscale Integration (Planned)
- Remote access to Compass from mobile
- Secure access without exposing ports

**Phase 6+:** ⏳ Messaging Bots (Planned)
- Telegram/WhatsApp integration
- Text-to-journal automation

## Architecture

Compass is built with:
- **Obsidian:** Knowledge management and journaling
- **Docker:** Containerized deployment
- **n8n:** Workflow automation (Phase 2+)
- **MCP:** AI integration protocol (Phase 4+)

See [docs/architecture/](docs/architecture/) for technical details.

## For Developers

- **Project Plan:** [docs/development/project-plan.md](docs/development/project-plan.md)
- **Architecture Docs:** [docs/architecture/](docs/architecture/)
- **Claude Code Guide:** [CLAUDE.md](CLAUDE.md)
- **Contributing:** See project plan for branch strategy

### Development Setup

```bash
# Work on a feature
git checkout -b feature/your-feature

# Test locally
docker compose up --build

# Commit your changes
git commit -m "Description of changes"
```

## Why Compass?

Built on proven principles:
- **Daily journaling** improves mental health and clarity
- **Telos framework** provides direction and purpose
- **AI assistance** offers insights humans might miss
- **Low friction** makes it accessible when you need it most

## Privacy & Data

- ✅ Runs completely on your machine
- ✅ No cloud services required
- ✅ Your data never leaves your control
- ✅ Optional cloud sync (your choice)

## Support

- **Issues:** [GitHub Issues](https://github.com/timgrote/Compass-Project/issues)
- **Documentation:** [docs/](docs/)
- **Architecture:** [docs/architecture/](docs/architecture/)

## Mission

*"Build better systems that improve quality of life for all life on Earth"*

Compass is one small system in service of this mission.

---

**Current Version:** Phase 1 (Development)
**Last Updated:** 2025-10-05
