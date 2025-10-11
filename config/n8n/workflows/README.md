# n8n Workflow Templates

This directory contains pre-built workflow templates for Compass automation.

## Phase 2 Workflows

Currently empty - workflows will be created manually during Phase 2 development.

## Phase 3+ (Automated Setup)

Future workflow templates will be placed here for automatic import on first run:
- Daily journal creation
- Weekly reflection prompts
- Monthly review automation
- Custom user workflows

## How to Use (Manual Setup - Phase 2)

1. Access n8n at http://localhost:5678
2. Create a new workflow
3. Add nodes to interact with Obsidian API
4. Export workflow JSON and save here for sharing

## Obsidian API Connection Details

**Base URL:** `http://compass-obsidian:27123`
**Auth Type:** Header Auth
**Header Name:** `Authorization`
**Header Value:** `Bearer 7f3217c2ffa638a1a0233c069d014de7282bcdebd9fee4c3eb7046a1884a80ef`

See [../../docs/ai-session-notes/2025-10-05-rest-api-configuration.md](../../docs/ai-session-notes/2025-10-05-rest-api-configuration.md) for API endpoint documentation.
