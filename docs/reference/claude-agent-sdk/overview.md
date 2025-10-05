# Claude Agent SDK Overview

The **Claude Agent SDK** (formerly Claude Code SDK) enables developers to build AI agents with advanced capabilities across various domains.

## What Changed from Claude Code SDK?

The SDK was renamed to reflect its expanded capabilities beyond just coding tasks:

**Package Names:**
- **TypeScript/JS:** `@anthropic-ai/claude-code` → `@anthropic-ai/claude-agent-sdk`
- **Python:** `claude-code-sdk` → `claude-agent-sdk`

**Major Changes:**
1. No default system prompt
2. Settings sources no longer automatically loaded
3. More explicit configuration options

## Installation

```bash
npm install @anthropic-ai/claude-agent-sdk
```

**Requirements:** Node.js 18+

## Key Capabilities

- **Codebase Understanding:** Analyze and comprehend complex code structures
- **File Editing:** Programmatically modify files
- **Command Execution:** Run shell commands and scripts
- **Complex Workflows:** Execute multi-step tasks autonomously
- **Tool Use:** Integrate custom tools and APIs
- **Model Context Protocol (MCP):** Connect to external data sources and services

## Use Cases

### Business Agents
- Legal document processing
- Financial analysis and reporting
- Customer support automation

### Coding Agents
- Code review and analysis
- Automated refactoring
- Test generation

### Custom Domain Agents
- Healthcare record processing
- Scientific research assistance
- Content creation and editing

## Core Architecture

The SDK provides:
- Flexible agent configuration system
- Tool use framework
- MCP integration for external context
- Multi-step task execution
- File system operations

## Related Documentation

- [Claude Messages API](../claude-api/messages-api.md) - Core API for Claude interactions
- [MCP Overview](../mcp/overview.md) - Model Context Protocol integration
- [Official Agent SDK Docs](https://docs.claude.com/en/api/agent-sdk/overview)

## Privacy & Data Usage

When using the Claude Agent SDK, Anthropic collects:
- Usage data and feedback
- Limited retention periods
- Restricted data access
- No model training with user data (per Commercial Terms)

Review full details:
- [Anthropic Commercial Terms](https://www.anthropic.com/legal/commercial-terms)
- [Privacy Policy](https://www.anthropic.com/legal/privacy)

## Community & Support

- **Report bugs:** [GitHub Issues](https://github.com/anthropics/claude-agent-sdk/issues)
- **Community support:** Claude Developers Discord
- **Official docs:** https://docs.claude.com/en/api/agent-sdk/overview
