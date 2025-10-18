# Conversation Vault

A shared Obsidian vault for async conversation and collaborative idea development.

## Purpose

This vault is a space for two people to:
- Have ongoing threaded conversations that persist across time
- Develop ideas collaboratively
- Share and analyze interesting links
- Document shared projects
- Maintain personal spaces visible to each other

## Structure

```
/Conversations/     Main async discussion space
/Ideas/             Shared idea repository
/Tim-Notes/         Tim's space (read-only for others)
/Hunter-Notes/      Hunter's space (read-only for others)
/Links/             Shared link library with analysis
/Setup/             Technical documentation
/.templates/        Note templates (Templater)
```

## How to Use This Vault

### Starting a Conversation

1. Create a new note in `/Conversations/` using the conversation template
2. Give it a descriptive name: `AI Agent Communication.md`, `Costa Rica Trip Planning.md`
3. Add your initial thoughts
4. Tag with status: `#open`, `#evolving`, or `#closed`

**Convention**: Add dated entries as you think of things. The other person responds inline or adds their own dated entry. It's async - no pressure for immediate response.

### Capturing Ideas

1. Create a note in `/Ideas/` or use the idea template
2. Start simple - just capture the core concept
3. Add `originated-by: Tim` or `originated-by: Hunter` in frontmatter
4. Link to related conversations, projects, or other ideas
5. Tag by category: `#ai`, `#crypto`, `#philosophy`, `#project`, etc.

**Graduation**: When an idea gets substantial, it can be extracted to its own project in `/Projects/` or developed further.

### Sharing Links

1. Add to `/Links/` using the link template
2. Include the URL and why it's relevant
3. Add your analysis or key takeaways
4. The other person can add their perspective

### Personal Notes

Use your personal folder (`/Tim-Notes/` or `/Hunter-Notes/`) for:
- Thoughts you want to share but not co-edit
- "What I'm working on" updates
- Travel journals or reflections
- Context for ongoing conversations

**Convention**: These are read-only for the other person. They can reference but not edit.

### Meeting/Call Notes

After calls, capture notes in `/Conversations/` with the date in the filename:
- `Call Notes 2025-10-18.md`
- Include action items, decisions, topics discussed
- Link to ideas or projects mentioned

## Conventions

### Tagging
- **Status**: `#open`, `#evolving`, `#closed`
- **Category**: `#ai`, `#crypto`, `#pkms`, `#philosophy`, `#business`, `#travel`, `#relationships`
- **Action**: `#todo`, `#question`, `#decision-needed`

### Mentions
Use `@Tim` or `@Hunter` to flag something for the other person's attention.

### Linking
Link liberally! Connect conversations to ideas, ideas to other ideas, notes to links. The graph is the magic.

### Dates
Use `YYYY-MM-DD` format for consistency in dated entries.

## Suggested Workflows

### Async Threading
```markdown
## 2025-10-18 - Tim
Initial thought about [topic]...

## 2025-10-19 - Hunter
Response to your point about [topic]...
What about [new angle]?

## 2025-10-20 - Tim
Great question! Here's what I'm thinking...
```

### Idea Collaboration
```markdown
# Core Concept
Brief description...

## Tim's Perspective
- Point 1
- Point 2

## Hunter's Perspective
- Different angle
- Additional context

## Synthesis
Where our thinking converges...
```

### Status Updates
Add a weekly note to your personal folder:
```markdown
# Week of 2025-10-14

## What I'm Working On
- Project X
- Research into Y

## What I'm Thinking About
- [[Ideas/Concept Z]]
- Question about [topic]

## Links Worth Sharing
- [Article](url) - why it's interesting
```

## Technical Setup

See `/Setup/Deployment Guide.md` for:
- Obsidian Web configuration
- VPN/network security
- Crypto sign-in integration
- Automation setup (Telegram, etc.)

## Future Enhancements

Potential additions as the vault evolves:
- **Bots Talking to Bots**: AI agent interaction experiments
- **Verification Layer**: Crypto signatures on messages
- **Semantic Search**: AI-powered meaning-based connections
- **Automation**: Telegram → vault, voice transcription
- **Canvas Boards**: Visual idea development
- **Projects**: Full project management for collaborations

## Getting Started

1. Read this README
2. Check out the example conversation in `/Conversations/`
3. Create your first note using a template
4. Start a conversation or share an idea
5. Link things together and see what emerges

The vault is a living space - let it evolve organically!
