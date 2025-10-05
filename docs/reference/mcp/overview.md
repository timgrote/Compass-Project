# Model Context Protocol (MCP)

The **Model Context Protocol** is an open-source standard that enables AI applications to connect with external systems like data sources, tools, and workflows.

## What is MCP?

Think of MCP as a **"USB-C port for AI applications"** - a universal standard that allows AI to access:

- **Personal data sources:** Google Calendar, Notion, email
- **Enterprise systems:** Databases, CRMs, analytics platforms
- **Design tools:** Figma, Adobe Creative Suite
- **Development tools:** GitHub, IDEs, testing frameworks
- **Workflow automation:** n8n, Zapier, custom scripts

## Core Concept

Instead of building custom integrations for every AI application + data source combination, MCP provides a standardized protocol:

```
┌─────────────┐         ┌──────────────┐         ┌──────────────┐
│ AI Client   │ ◄─MCP─► │  MCP Server  │ ◄─────► │ Data Source  │
│ (Claude)    │         │  (Protocol)  │         │ (Obsidian)   │
└─────────────┘         └──────────────┘         └──────────────┘
```

## Benefits

### For Developers
- **Reduced complexity:** Write one MCP server, works with all MCP clients
- **Reusability:** Share servers across projects and teams
- **Standard protocol:** Well-defined specification and tooling

### For AI Applications
- **Expanded capabilities:** Access any data source or tool
- **Ecosystem access:** Leverage community-built servers
- **Flexibility:** Mix and match servers as needed

### For End Users
- **More powerful AI:** Assistants can access their real data
- **Personalization:** AI understands user's context and workflows
- **Privacy:** Data stays under user control (can run locally)

## Architecture

### MCP Server
Exposes resources (data, tools, prompts) to AI clients:

```typescript
// Example: Exposing Obsidian vault as MCP resource
const server = new MCPServer({
  name: "obsidian-vault",
  version: "1.0.0"
});

server.registerTool({
  name: "read_note",
  description: "Read a note from Obsidian vault",
  schema: {
    type: "object",
    properties: {
      path: { type: "string" }
    }
  },
  handler: async ({ path }) => {
    return await obsidianAPI.read(path);
  }
});
```

### MCP Client
Connects to servers and uses exposed resources:

```typescript
// Example: Claude connecting to Obsidian MCP server
const client = new MCPClient();
await client.connect("http://localhost:3000");

const tools = await client.listTools();
const result = await client.callTool("read_note", {
  path: "Journal/2025-10-04.md"
});
```

## Core Components

### Resources
Data that can be read (files, database records, API responses):
```json
{
  "type": "resource",
  "uri": "vault://Journal/2025-10-04.md",
  "name": "Daily Journal - Oct 4",
  "mimeType": "text/markdown"
}
```

### Tools
Actions that can be performed (create, update, delete, execute):
```json
{
  "type": "tool",
  "name": "create_note",
  "description": "Create a new note in vault",
  "inputSchema": {
    "type": "object",
    "properties": {
      "path": { "type": "string" },
      "content": { "type": "string" }
    }
  }
}
```

### Prompts
Pre-configured prompts with dynamic context:
```json
{
  "type": "prompt",
  "name": "weekly_review",
  "description": "Generate weekly review from journal entries",
  "arguments": {
    "week": { "type": "string" }
  }
}
```

## Getting Started

### Building an MCP Server

1. **Install MCP SDK:**
```bash
npm install @modelcontextprotocol/sdk
```

2. **Create server:**
```typescript
import { MCPServer } from '@modelcontextprotocol/sdk';

const server = new MCPServer({
  name: "my-data-source",
  version: "1.0.0"
});

// Register resources, tools, prompts
server.start();
```

3. **Deploy:**
- Run locally (http://localhost:3000)
- Deploy to cloud (AWS, Google Cloud)
- Package in Docker container

### Using MCP in Claude Agent SDK

```typescript
import { Agent } from '@anthropic-ai/claude-agent-sdk';

const agent = new Agent({
  mcpServers: [
    {
      url: "http://localhost:3000",
      name: "obsidian-vault"
    }
  ]
});

// Agent now has access to Obsidian tools
await agent.run("Create a journal entry for today");
```

## MCP in Compass Project

For the Compass deployment, we'll use MCP to:

1. **Expose Obsidian vault to AI:**
   - Read/write journal entries
   - Search notes
   - Create templated content

2. **Connect n8n workflows:**
   - Trigger workflows from AI
   - Access workflow execution history
   - Manage automation

3. **Integration layer:**
   - Messaging platforms (Telegram/WhatsApp)
   - Calendar and scheduling
   - External APIs (weather, news, etc.)

### Planned MCP Servers (Phase 4)

```
containers/mcp-server/
├── obsidian-mcp/
│   ├── server.ts          # Obsidian vault MCP server
│   └── tools/
│       ├── read.ts
│       ├── write.ts
│       └── search.ts
├── n8n-mcp/
│   └── server.ts          # n8n workflow MCP server
└── config.json            # MCP server routing
```

## Related Documentation

- [Claude Agent SDK](../claude-agent-sdk/overview.md) - Using MCP in agents
- [Official MCP Specification](https://modelcontextprotocol.io/specification)
- [MCP GitHub Repository](https://github.com/modelcontextprotocol/specification)

## Technical Details

### Protocol
- **Transport:** HTTP/HTTPS, WebSockets, stdio
- **Format:** JSON-RPC 2.0
- **Schema:** TypeScript-first, JSON Schema for compatibility

### Language Support
- TypeScript/JavaScript (official SDK)
- Python (community)
- Go (community)
- Rust (community)

### Security
- Authentication: API keys, OAuth, custom auth
- Authorization: Per-resource access control
- Privacy: Can run entirely locally (no cloud required)

## Community

- **Specification:** MIT License
- **Contributors:** 260+ developers
- **Documentation:** https://modelcontextprotocol.io
- **Repository:** https://github.com/modelcontextprotocol/specification
