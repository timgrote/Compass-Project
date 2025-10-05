# Compass Reference Documentation

This directory contains reference documentation for the key technologies used in the Compass project.

## Quick Links

### Claude & Anthropic
- [Claude Agent SDK Overview](./claude-agent-sdk/overview.md) - Build AI agents with advanced capabilities
- [Claude Messages API](./claude-api/messages-api.md) - Core API for Claude interactions

### Model Context Protocol (MCP)
- [MCP Overview](./mcp/overview.md) - Connect AI to external data sources and tools

## Technology Stack

### AI & Agent Framework
**Claude Agent SDK** (formerly Claude Code SDK)
- Purpose: Build AI agents that understand codebases, edit files, and execute workflows
- Key features: Tool use, MCP integration, multi-step task execution
- Use cases: Business automation, coding assistance, custom domain agents

**Claude Messages API**
- Core interface for Claude model interactions
- Supports: Multi-turn conversations, vision, tool use, streaming
- Models: Claude Sonnet 4.5, Claude Opus, Claude Haiku

### Integration Layer
**Model Context Protocol (MCP)**
- Open standard for connecting AI to external systems
- Think: "USB-C port for AI applications"
- Enables: Data source access, tool integration, workflow automation

## How These Work Together in Compass

```
┌──────────────────────────────────────────────────────────────┐
│                    Compass Architecture                       │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  User Interaction                                             │
│  (Telegram/WhatsApp/Web)                                      │
│         │                                                     │
│         ▼                                                     │
│  ┌─────────────────┐                                         │
│  │  n8n Workflows  │ ◄── Automation & routing                │
│  └────────┬────────┘                                         │
│           │                                                   │
│           ▼                                                   │
│  ┌─────────────────┐         ┌──────────────┐               │
│  │  Claude Agent   │ ◄─MCP─► │  MCP Server  │               │
│  │  (AI Brain)     │         │  (Protocol)  │               │
│  └─────────────────┘         └──────┬───────┘               │
│           │                          │                        │
│           │                          ▼                        │
│           │                  ┌──────────────┐               │
│           │                  │   Obsidian   │               │
│           │                  │    Vault     │               │
│           │                  └──────────────┘               │
│           │                                                   │
│           ▼                                                   │
│  ┌─────────────────┐                                         │
│  │  Messages API   │ ◄── Direct Claude interactions          │
│  └─────────────────┘                                         │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### Data Flow Example: User Creates Journal Entry

1. **User sends message:** "I'm feeling grateful today"
2. **n8n receives webhook:** Routes to appropriate workflow
3. **Claude Agent processes:** Via Agent SDK + MCP
   - Understands intent: Create journal entry
   - Accesses context: Via MCP → Obsidian vault
   - Generates entry: Uses Messages API
4. **MCP Server executes:** Writes to Obsidian vault
5. **User receives confirmation:** Via messaging platform

### Key Integration Points

#### Phase 1-3: Basic Setup
- **Obsidian REST API:** Direct HTTP access to vault
- **n8n workflows:** Manual automation logic
- **No AI yet:** Focus on infrastructure

#### Phase 4: MCP Integration
- **MCP Server:** Wraps Obsidian REST API
- **Claude Agent SDK:** Connects to MCP server
- **AI-assisted:** Intelligent journal reflection

#### Phase 5+: Advanced Features
- **Multi-server MCP:** Obsidian + n8n + external APIs
- **Complex agents:** Pattern recognition, insights
- **Autonomous workflows:** AI-driven automation

## Docker Services & Technologies

| Service | Technology | Purpose | Phase |
|---------|-----------|---------|-------|
| `obsidian-api` | Obsidian Local REST API | Vault read/write | 1 |
| `n8n` | n8n workflow engine | Automation & routing | 2 |
| `postgres` | PostgreSQL | n8n persistence | 2 |
| `mcp-server` | MCP + Node.js | AI integration layer | 4 |

## External Resources

### Official Documentation
- [Claude Agent SDK Docs](https://docs.claude.com/en/api/agent-sdk/overview)
- [Claude API Reference](https://docs.claude.com/en/api/messages)
- [MCP Specification](https://modelcontextprotocol.io/specification)

### GitHub Repositories
- [Claude Agent SDK](https://github.com/anthropics/claude-agent-sdk)
- [Anthropic SDK TypeScript](https://github.com/anthropics/anthropic-sdk-typescript)
- [MCP Specification](https://github.com/modelcontextprotocol/specification)

### Additional Resources
- [Obsidian Local REST API](https://github.com/coddingtonbear/obsidian-local-rest-api)
- [n8n Documentation](https://docs.n8n.io/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

## When to Reference These Docs

### Claude Agent SDK
- Building AI agents (Phase 4+)
- Implementing tool use
- Configuring agent behavior
- Multi-step task execution

### Messages API
- Direct Claude API calls
- Understanding request/response format
- Implementing streaming
- Tool use and function calling

### MCP
- Designing server architecture (Phase 4)
- Exposing Obsidian vault to AI
- Connecting multiple data sources
- Understanding protocol specification

## Learning Path

### For Getting Started (Phase 1-3)
1. Docker & docker-compose basics
2. Obsidian REST API endpoints
3. n8n workflow creation

### For AI Integration (Phase 4+)
1. **Start here:** [MCP Overview](./mcp/overview.md)
   - Understand the protocol and architecture
   - See how it fits into Compass
2. **Then:** [Claude Messages API](./claude-api/messages-api.md)
   - Learn basic Claude interactions
   - Understand tool use
3. **Finally:** [Claude Agent SDK](./claude-agent-sdk/overview.md)
   - Build complex agents
   - Integrate everything together

## Contributing to These Docs

These docs are simplified extracts from official sources, tailored for Compass development.

**To update:**
1. Check official docs for latest changes
2. Use `WebFetch` to pull updated content
3. Maintain Markdown formatting and cross-links
4. Keep examples relevant to Compass use cases

**Last updated:** 2025-10-04
