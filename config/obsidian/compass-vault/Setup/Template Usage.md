# Template Usage Guide

How to use the Templater templates in this vault.

## Prerequisites

Install the **Templater** plugin in Obsidian:

1. Open Obsidian Settings
2. Go to Community Plugins
3. Browse and search for "Templater"
4. Install and enable

## Template Configuration

### Set Template Folder

1. Obsidian Settings → Templater
2. Set "Template folder location" to `.templates`
3. Enable "Trigger Templater on new file creation" if desired

### Hotkey (Optional)

Set a hotkey for inserting templates:
- Settings → Hotkeys → Search "Templater: Insert Template"
- Assign your preferred key (e.g., `Cmd+T`)

## Available Templates

### Conversation Template

**File**: `.templates/Conversation.md`

**Use when**: Starting a new threaded discussion with Hunter

**Creates**:
- Frontmatter with date, participants, status
- Initial dated entry section
- Notes section for ongoing thoughts

**Usage**:
1. Create new note in `/Conversations/`
2. Name it descriptively: `AI Agent Architecture.md`
3. Insert template (hotkey or command palette)
4. Fill in your initial thoughts

**Example**: See [[Conversations/Example - AI Agent Communication]]

---

### Idea Template

**File**: `.templates/Idea.md`

**Use when**: Capturing a new idea for collaborative development

**Creates**:
- Frontmatter with creation date, originator, status
- Core concept section
- Separate perspective sections for Tim and Hunter
- Related links section
- Evolution log to track development

**Usage**:
1. Create new note in `/Ideas/`
2. Name it with the core concept: `Verifiable ML Models.md`
3. Insert template
4. Fill in `originated-by` field
5. Capture initial thoughts

**Example**: See [[Ideas/Example - Semantic Search for PKM]]

---

### Link Template

**File**: `.templates/Link.md`

**Use when**: Sharing an interesting article, video, or resource

**Creates**:
- Frontmatter with URL, date, shared-by
- Relevance explanation
- Key takeaways
- Analysis sections for both people
- Related links

**Usage**:
1. Create new note in `/Links/`
2. Name it with article title: `Vitalik on Openness.md`
3. Insert template
4. Fill in URL and `shared-by` field
5. Add your analysis

**Example**: See [[Links/Example - Vitalik on Openness and Verifiability]]

---

### Meeting Notes Template

**File**: `.templates/Meeting Notes.md`

**Use when**: Documenting a call or video meeting

**Creates**:
- Frontmatter with date, participants, duration
- Topics discussed sections
- Links shared
- Ideas generated (with links to `/Ideas/`)
- Action items with owner tags
- Follow-up conversations

**Usage**:
1. Create note in `/Conversations/` (meetings are conversations!)
2. Name with date: `Call Notes 2025-10-18.md`
3. Insert template
4. Fill in during or after call

**Tip**: Use this to extract action items and ideas into their own notes after the call.

---

### Weekly Update Template

**File**: `.templates/Weekly Update.md`

**Use when**: Sharing a weekly status update in your personal folder

**Creates**:
- Frontmatter with week date, author
- What I'm working on
- What I'm thinking about
- Reading/watching list
- Questions for discussion
- Personal updates

**Usage**:
1. Create note in `/Tim-Notes/` or `/Hunter-Notes/`
2. Name with week date: `Week of 2025-10-14.md`
3. Insert template
4. Fill in your updates

**Tip**: Do this Friday afternoon or Monday morning to maintain rhythm.

**Example**: See [[Tim-Notes/Example - Week of 2025-10-14]]

---

## Templater Syntax

The templates use Templater's syntax:

- `2025-10-18` - Inserts current date
- `Template Usage` - Inserts the file name
- Fields like `status:`, `tags:`, `originated-by:` - Fill these manually

## Customizing Templates

Feel free to modify the templates! Common customizations:

### Add New Fields

In frontmatter:
```yaml
---
priority: high
deadline: 2025-12-31
related-project:
---
```

### Add New Sections

```markdown
## Implementation Notes

*Technical details, code snippets, etc.*
```

### Change Date Format

Prefer different date format? Change this:
```
2025-10-18
```

To:
```
Oct 18, 2025  # Oct 18, 2025
Saturday, October 18  # Friday, October 18
```

[Full date format reference](https://momentjs.com/docs/#/displaying/format/)

## Workflows

### Capturing from a Call

1. During call: Create note with **Meeting Notes** template
2. Fill in topics, links, action items
3. After call: Extract ideas to `/Ideas/` using **Idea** template
4. Link meeting notes to idea notes

### Developing an Idea

1. Initial capture: Use **Idea** template, keep it brief
2. Discussion: Reference idea in **Conversation** note
3. Evolution: Update idea note with new insights
4. Graduation: When substantial, consider extracting to project

### Weekly Rhythm

- **Monday**: Create **Weekly Update** with intentions
- **Throughout week**: Add to conversations, ideas, links
- **Friday**: Update weekly note with reflections
- **Monthly**: Review all activity, create synthesis

## Tips

### Use Placeholders

When creating template, leave placeholders for common values:

```markdown
originated-by: [Tim/Hunter]
status: [seed/evolving/mature]
tags: [add, relevant, tags]
```

Then fill in when inserting.

### Combine Templates

Start with one template, add sections from another:
- Conversation that becomes an idea
- Meeting notes with link analysis sections

### Create Your Own

Follow the pattern:
1. Create `.md` file in `.templates/`
2. Use Templater syntax for dynamic content
3. Structure with frontmatter + sections
4. Test by inserting into a new note

## Troubleshooting

### Template not showing up
- Check Templates folder is set to `.templates` in settings
- Restart Obsidian if you just added new template

### Date not inserting
- Ensure Templater plugin is enabled
- Check syntax: `2025-10-18`

### Fields not auto-filling
- Some fields are meant to be filled manually (status, tags, etc.)
- Only `tp.*` commands execute automatically

---

**Experiment and iterate!** The templates are starting points - adapt them to how you and Hunter actually work together.
