# n8n Setup Guide

This guide walks you through setting up n8n for Compass workflow automation.

## Table of Contents
- [First-Time Setup](#first-time-setup)
- [Obsidian API Credential](#obsidian-api-credential)
- [Testing Connectivity](#testing-connectivity)
- [Creating Your First Workflow](#creating-your-first-workflow)
- [Troubleshooting](#troubleshooting)

## First-Time Setup

### 1. Access n8n

Open your browser to **http://localhost:5678**

On first visit, you'll see the n8n setup screen.

### 2. Create Owner Account

Fill in the form:
- **Email:** Your email address (used for login)
- **First Name:** Your name
- **Last Name:** Your last name
- **Password:** Choose a strong password

Click "Next" to complete setup.

### 3. n8n Dashboard

You'll land on the n8n dashboard. This is where you'll:
- Create workflows
- Manage credentials
- View execution history
- Configure settings

## Obsidian API Credential

To allow n8n to communicate with your Obsidian vault, you need to set up an API credential.

### Why This Is Needed

n8n needs to authenticate with the Obsidian REST API plugin. The API requires an Authorization header with a Bearer token on every request.

### Setup Steps

**1. Open Credentials Settings**
- Click your **profile icon** (top right corner)
- Select **"Settings"**
- Click **"Credentials"** in the left sidebar

**2. Add New Credential**
- Click the **"Add Credential"** button
- Search for **"Header Auth"**
- Click on it to create a new credential

**3. Configure the Credential**

Fill in the following fields:

| Field | Value |
|-------|-------|
| **Credential Name** | `Obsidian REST API` |
| **Name** | `Authorization` |
| **Value** | `Bearer 7f3217c2ffa638a1a0233c069d014de7282bcdebd9fee4c3eb7046a1884a80ef` |

**Important Notes:**
- The credential name is just for you to identify it in workflows
- The "Name" field is the HTTP header name (`Authorization`)
- The "Value" field must start with `Bearer ` followed by the API key
- Do NOT include quotes around the value

**4. Save the Credential**
- Click **"Save"** button
- The credential is now ready to use in workflows

### Security Considerations

**This API key is for local use only:**
- Only works within the Docker network
- Not exposed to the internet
- Unique to your Compass installation
- Can be regenerated in Obsidian if needed

**Best Practices:**
- Don't share your API key in screenshots or logs
- Don't commit credentials to version control (they're stored in n8n's database)
- Keep your n8n password secure

### How to Find Your API Key

If you need to regenerate or find your API key:

1. Open Obsidian at http://localhost:3000
2. Go to **Settings → Community Plugins**
3. Find **"Local REST API"** and click the gear icon
4. Your API key is shown in the settings

## Testing Connectivity

Let's verify that n8n can communicate with Obsidian.

### Create a Test Workflow

**1. Create New Workflow**
- From the n8n dashboard, click **"Add Workflow"**
- Give it a name: "Test Obsidian Connection"

**2. Add Manual Trigger**
- Click **"Add first step"**
- Search for **"Manual Trigger"**
- Click to add it (no configuration needed)

**3. Add HTTP Request Node**
- Click the **+** button after the Manual Trigger
- Search for **"HTTP Request"**
- Click to add it

**4. Configure HTTP Request**

Fill in the following settings:

| Field | Value |
|-------|-------|
| **Method** | `GET` |
| **URL** | `http://compass-obsidian:27123/` |
| **Authentication** | Select "Predefined Credential Type" → "Header Auth" |
| **Credential for Header Auth** | Select "Obsidian REST API" |

**5. Test the Connection**
- Click **"Test step"** button
- You should see a JSON response with:
  ```json
  {
    "status": "OK",
    "manifest": {
      "name": "Local REST API",
      "version": "3.2.0",
      ...
    }
  }
  ```

**6. Success! ✅**

If you see the response, n8n can successfully communicate with Obsidian.

### Troubleshooting Connection Issues

**If you get an error:**

| Error | Solution |
|-------|----------|
| Connection refused | Check that Obsidian container is running: `docker ps` |
| Unauthorized (401) | Verify your API key in the credential is correct |
| Not found (404) | Check the URL - should be `http://compass-obsidian:27123` |
| DNS resolution failed | Container names must resolve - check Docker network |

**To check container status:**
```bash
docker-compose ps
```

All services should show `Up` and `(healthy)` status.

## Creating Your First Workflow

Now that connectivity is working, let's create a useful workflow.

### Daily Journal Entry

This workflow will automatically create a daily journal entry in your Obsidian vault.

**1. Create New Workflow**
- Click **"Workflows" → "Add Workflow"**
- Name it: "Daily Journal Creation"

**2. Add Schedule Trigger**
- Add a **"Schedule Trigger"** node
- Set to run daily at 8:00 AM (or your preferred time)

**3. Add HTTP Request to Create Note**
- Add an **"HTTP Request"** node
- Configure:
  - **Method:** `PUT`
  - **URL:** `http://compass-obsidian:27123/vault/Daily%20Notes/{{ $now.format('yyyy-MM-dd') }}.md`
  - **Authentication:** Use "Obsidian REST API" credential
  - **Send Body:** Enable
  - **Body Content Type:** `Raw/Custom`
  - **Body:**
    ```markdown
    # Daily Journal - {{ $now.format('MMMM d, yyyy') }}

    ## Morning Reflection
    - What am I grateful for today?
    - What are my top 3 priorities?

    ## Evening Reflection
    - What went well today?
    - What could I improve tomorrow?
    - How am I feeling?

    ## Notes

    ```

**4. Activate the Workflow**
- Toggle the switch at the top to **"Active"**
- The workflow will now run every day at 8 AM

**5. Test Manually**
- Click **"Test workflow"** to create today's entry immediately
- Check Obsidian at http://localhost:3000 to see the new note

## Understanding n8n Basics

### Workflow Components

**Triggers:**
- Start workflows (Schedule, Webhook, Manual)
- When to run automation

**Nodes:**
- Actions to perform (HTTP Request, Set, IF, etc.)
- What to do

**Connections:**
- Link nodes together
- Data flows from left to right

### Using the Obsidian API

**Base URL:** `http://compass-obsidian:27123`

**Common Endpoints:**

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/` | GET | Check API status |
| `/vault/` | GET | List all notes |
| `/vault/{path}` | GET | Read a note |
| `/vault/{path}` | PUT | Create/update note |
| `/vault/{path}` | PATCH | Append to note |
| `/vault/{path}` | DELETE | Delete note |

**Path Encoding:**
- Spaces become `%20` (e.g., `Daily%20Notes`)
- Use forward slashes for folders: `Daily%20Notes/2025-10-06.md`

**Dynamic Dates in n8n:**
- Today: `{{ $now.format('yyyy-MM-dd') }}`
- Tomorrow: `{{ $now.plus({days: 1}).format('yyyy-MM-dd') }}`
- Custom format: `{{ $now.format('MMMM d, yyyy') }}` → "October 6, 2025"

### Execution History

- Click **"Executions"** in left sidebar
- See all workflow runs
- Debug failed executions
- View input/output data

## Common Workflows

### 1. Weekly Review Prompt
- **Trigger:** Schedule (Sundays at 6 PM)
- **Action:** Create weekly review note with reflection questions

### 2. Monthly Goals Check-in
- **Trigger:** Schedule (1st of month)
- **Action:** Create monthly goals tracking note

### 3. Append Daily Gratitude
- **Trigger:** Webhook (can be called from phone)
- **Action:** Append gratitude entry to today's note

### 4. Backup to Cloud (Optional)
- **Trigger:** Schedule (daily)
- **Action:** Export vault as ZIP and upload to cloud storage

## Troubleshooting

### n8n Won't Start

**Check logs:**
```bash
docker-compose logs n8n
```

**Common issues:**
- PostgreSQL not ready → wait 30 seconds and check again
- Port 5678 already in use → change port in `.env` file

### Workflow Execution Fails

**Check execution details:**
1. Go to "Executions" in n8n
2. Click on the failed execution
3. Review error message and data

**Common issues:**
- Wrong API key → recreate credential
- Wrong URL → use `http://compass-obsidian:27123`
- Note already exists → use POST instead of PUT, or add IF node

### Credential Not Working

**Verify credential setup:**
1. Settings → Credentials
2. Click "Obsidian REST API"
3. Verify:
   - Name field: `Authorization`
   - Value starts with: `Bearer `
   - API key matches Obsidian settings

**Test credential:**
- Create simple workflow with HTTP Request to `/`
- Use "Test step" to verify response

### Notes Not Appearing in Obsidian

**Refresh the vault:**
- Obsidian caches files
- Press F5 or click "Reload" in Obsidian

**Check file was created:**
```bash
docker exec compass-obsidian ls /config/Compass/
```

## Advanced Topics

### Environment Variables

You can use environment variables in workflows:
- Store sensitive data
- Configure different behavior per environment

### Webhooks

Create webhook triggers to call workflows from:
- Mobile apps (via URL)
- Other services
- Custom scripts

### Sub-workflows

Break complex automations into smaller, reusable workflows.

### Error Handling

Add error handling nodes:
- IF nodes to check conditions
- Error trigger to catch failures
- Notifications on error

## Next Steps

Once you're comfortable with n8n:
1. Explore the n8n node library (400+ integrations)
2. Join n8n community for workflow ideas
3. Build custom workflows for your needs
4. Share your workflows with the Compass community

## Resources

- **n8n Documentation:** https://docs.n8n.io/
- **Obsidian REST API Docs:** https://github.com/coddingtonbear/obsidian-local-rest-api
- **Compass Docs:** [../README.md](../README.md)
- **API Session Notes:** [ai-session-notes/2025-10-05-rest-api-configuration.md](ai-session-notes/2025-10-05-rest-api-configuration.md)

---

**Questions or issues?** Open an issue on GitHub or check the troubleshooting section above.
