---
created: 2025-10-09
originated-by: Hunter
tags: [idea, pkms, ai, search]
status: seed
---

# Semantic Search for PKM

*First captured: 2025-10-09*

## Core Concept

Current PKM tools (including Obsidian) link words, not meanings. "Stress" (physics) links to "stress" (psychology) even though they're completely different concepts. True semantic search would understand meaning and context, not just syntax.

## Context

Hunter shared his [[Links/Reddit PKMS Thread]] about this gap. He's proud of articulating the problem clearly.

The limitation: Obsidian's graph connects based on exact text matches. AI semantic embeddings could create true meaning-based connections.

## Initial Thoughts

### Tim's Perspective

This is exactly what I've been experiencing! My vault has:
- "Execution" (business strategy from Naval)
- "Execution" (legal term - capital punishment)
- "Execute" (running code)

Obsidian treats these as related. They're not.

AI with embeddings could understand:
- Execution (business) → relates to "implementation", "action", "strategy"
- Execution (legal) → relates to "death penalty", "justice system"
- Execute (code) → relates to "runtime", "programming", "software"

**Prototype idea**: Use local LLM with embeddings to generate semantic links in vault. Compare to Obsidian's syntactic graph.

### Hunter's Perspective

The deeper issue: Most "semantic search" tools are still syntactic underneath. They do fuzzy matching or vector similarity on text, but don't truly understand meaning.

Real semantic search needs:
- Context awareness (same word, different meanings in different notes)
- Relationship types (not just "related" but "contrasts with", "builds on", "criticizes")
- Temporal evolution (meaning shifts as you learn more)

This is where knowledge graphs + LLMs get interesting. The graph provides structure, the LLM provides comprehension.

## Related

- [[Conversations/AI Agent Communication]] - Agents need semantic understanding to route messages
- [[Links/Reddit PKMS Thread]] - Hunter's original post
- [[Ideas/AI-Powered Vault Orchestration]] - Semantic layer could drive smart automation

## Next Steps

- [ ] @Hunter: Share examples from your vault where syntactic fails
- [ ] @Tim: Prototype embedding-based semantic link generation
- [ ] Both: Research existing tools attempting this (Mem.ai, Notion AI, etc.)
- [ ] Explore: Could Tiny Cloud protocol include semantic layer?

---

## Evolution Log

**2025-10-09**: Initial capture from Hunter's Reddit post discussion
**2025-10-10**: Tim added business execution example and prototype idea
**2025-10-11**: Hunter expanded with relationship types and knowledge graph angle
