---
created: 2025-10-08
participants: [Tim, Hunter]
status: evolving
tags: [conversation, ai, automation, crypto]
---

# AI Agent Communication

## 2025-10-08 - Tim

Been thinking about your "bots talking to bots" idea from our call. What if we built a system where AI agents can communicate with digitally signed messages?

The use case: My vault's AI agent could send a verified message to your vault's AI agent. Each agent acts on behalf of its owner, but the crypto signature proves authenticity.

Relevant to our Obsidian multiplayer project - the automation layer could use this for verified async updates.

## 2025-10-09 - Hunter

Love this direction. Reminds me of that [[Links/Aquafier Protocol]] link I shared - verifiable data through hasher/verifier pattern.

Key question: What's the identity model? Do we use:
- Ethereum addresses (already have infra)
- DIDs (more formal, W3C standard)
- Custom key pairs (simpler, less baggage)

Also thinking about message format. JSON-LD? Plain JSON with JWS? Protobuf?

@Tim - want to prototype something minimal this week?

## 2025-10-10 - Tim

I vote custom key pairs to start. Keep it simple, prove the pattern, then generalize.

Message format: JSON with JWS signature feels right. Human-readable, standard libraries everywhere.

Basic schema:
```json
{
  "from": "pubkey-hash-or-identifier",
  "to": "pubkey-hash-or-identifier",
  "timestamp": "2025-10-10T14:30:00Z",
  "message": {
    "type": "vault-update",
    "content": {...}
  },
  "signature": "..."
}
```

I can build a proof-of-concept this weekend. Two local agents, key generation, sign/verify flow.

**Action items**:
- [ ] @Tim: Build local agent PoC with key generation and message signing
- [ ] @Hunter: Review crypto libraries for JS/TS - recommendations?
- [ ] Both: Think about message types beyond vault-update

## Notes

This connects to:
- [[Ideas/Verification Agent]] - Could be the foundation
- [[Ideas/Tiny Cloud Integration]] - Natural fit for data ownership model
- Our crypto sign-in commitment - Same key infra could work

---

**Status**: #open - Actively prototyping
