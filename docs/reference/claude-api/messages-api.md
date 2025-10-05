# Claude Messages API

The Messages API is the core interface for interacting with Claude models.

## Endpoint

```
POST https://api.anthropic.com/v1/messages
```

## Authentication

Required headers:
```http
x-api-key: YOUR_API_KEY
anthropic-version: 2023-06-01
```

## Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | string | Claude model identifier (e.g., `claude-sonnet-4-5-20250929`) |
| `messages` | array | List of conversation turns with `role` and `content` |
| `max_tokens` | integer | Maximum tokens to generate (required) |

## Basic Request Example

```json
{
    "model": "claude-sonnet-4-5-20250929",
    "max_tokens": 1024,
    "messages": [
        {
            "role": "user",
            "content": "Hello, world"
        }
    ]
}
```

## Response Structure

```json
{
    "id": "msg_123456789",
    "type": "message",
    "role": "assistant",
    "content": [
        {
            "type": "text",
            "text": "Hello! How can I help you today?"
        }
    ],
    "model": "claude-sonnet-4-5-20250929",
    "stop_reason": "end_turn",
    "usage": {
        "input_tokens": 10,
        "output_tokens": 15
    }
}
```

## Response Fields

| Field | Description |
|-------|-------------|
| `id` | Unique message identifier |
| `content` | Generated message content (array) |
| `role` | Always `"assistant"` for responses |
| `stop_reason` | Why generation stopped (`end_turn`, `max_tokens`, `stop_sequence`) |
| `usage` | Token consumption details |

## Optional Parameters

### System Prompt
```json
{
    "system": "You are a helpful assistant focused on technical documentation.",
    "model": "claude-sonnet-4-5-20250929",
    "messages": [...]
}
```

### Temperature (Creativity)
```json
{
    "temperature": 0.7,
    "model": "claude-sonnet-4-5-20250929",
    "messages": [...]
}
```

Range: 0.0 (deterministic) to 1.0 (creative)

### Multi-turn Conversations
```json
{
    "model": "claude-sonnet-4-5-20250929",
    "messages": [
        {"role": "user", "content": "What is Docker?"},
        {"role": "assistant", "content": "Docker is a containerization platform..."},
        {"role": "user", "content": "How do I install it?"}
    ],
    "max_tokens": 1024
}
```

## Advanced Features

### Vision (Image Content)
```json
{
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/jpeg",
                        "data": "/9j/4AAQSkZJRg..."
                    }
                },
                {
                    "type": "text",
                    "text": "What's in this image?"
                }
            ]
        }
    ]
}
```

### Tool Use
```json
{
    "tools": [
        {
            "name": "get_weather",
            "description": "Get current weather for a location",
            "input_schema": {
                "type": "object",
                "properties": {
                    "location": {"type": "string"}
                }
            }
        }
    ],
    "messages": [...]
}
```

## Using the TypeScript SDK

```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({
  apiKey: process.env['ANTHROPIC_API_KEY'],
});

const message = await client.messages.create({
  max_tokens: 1024,
  messages: [{ role: 'user', content: 'Hello, Claude' }],
  model: 'claude-sonnet-4-5-20250929',
});

console.log(message.content);
```

### Streaming Responses

```typescript
const stream = await client.messages.create({
  max_tokens: 1024,
  messages: [{ role: 'user', content: 'Hello, Claude' }],
  model: 'claude-sonnet-4-5-20250929',
  stream: true,
});

for await (const messageStreamEvent of stream) {
  if (messageStreamEvent.type === 'content_block_delta') {
    console.log(messageStreamEvent.delta.text);
  }
}
```

## Related Documentation

- [Claude Agent SDK](../claude-agent-sdk/overview.md) - Build complex AI agents
- [Anthropic SDK TypeScript](https://github.com/anthropics/anthropic-sdk-typescript)
- [Official API Reference](https://docs.claude.com/en/api/messages)

## Installation (TypeScript SDK)

```bash
npm install @anthropic-ai/sdk
```

## Error Handling

The SDK provides detailed error types:
```typescript
try {
  const message = await client.messages.create({...});
} catch (error) {
  if (error instanceof Anthropic.APIError) {
    console.error('API Error:', error.status, error.message);
  }
}
```
