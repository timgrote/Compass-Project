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

Open your browser to **http://localhost:3000**

Obsidian will launch with your personal Compass vault, ready for journaling.

## What's Inside

- 📓 Pre-configured Obsidian vault with journaling templates
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

- **Developer Guide:** [DEVELOPER-GUIDE.md](DEVELOPER-GUIDE.md) - Full feature list, roadmap, and management
- **Claude Code Guide:** [CLAUDE.md](CLAUDE.md) - For AI-assisted development
- **Architecture:** [docs/architecture/](docs/architecture/) - Technical documentation

---

**Status:** Phase 1 Development | **License:** TBD
