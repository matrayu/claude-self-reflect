# Understanding Claude MCP Scopes

This document explains the confusing MCP scope system that caused installation issues.

## The Problem

Running `claude mcp add` without understanding scopes leads to confusion:
- MCP servers appear to "vanish" when switching projects
- Installation from home directory doesn't make it "global"
- The default behavior is NOT what most users want

## MCP Scope Types

### 1. `local` (Default - The Confusing One)
```bash
claude mcp add my-server /path/to/server
# OR
claude mcp add my-server /path/to/server --scope local
```
- **Availability**: ONLY in the exact directory where you ran the command
- **Config location**: `~/.claude.json` with `[project: /exact/path]`
- **Problem**: Running from `~/Projects` makes it only available in `~/Projects`, not in `~/Projects/my-app`

### 2. `user` (What You Usually Want)
```bash
claude mcp add my-server /path/to/server --scope user
```
- **Availability**: ALL your projects
- **Config location**: `~/.claude.json` in the global `mcpServers` section
- **Benefit**: Install once, use everywhere

### 3. `project` (For Team Sharing)
```bash
claude mcp add my-server /path/to/server --scope project
```
- **Availability**: Current project (via `.mcp.json` file)
- **Config location**: `.mcp.json` in the project root
- **Benefit**: Can be committed to git for team sharing

## Real Example: The Confusion

```bash
# User runs from home directory thinking it's "global"
cd ~
claude mcp add claude-self-reflect /path/to/server

# Result: Only works when Claude is started from ~ exactly
# Config shows: [project: /Users/username]
```

```bash
# User runs from ~/Projects thinking it covers all projects
cd ~/Projects
claude mcp add claude-self-reflect /path/to/server

# Result: Only works in ~/Projects, NOT in ~/Projects/my-app
# Config shows: [project: /Users/username/Projects]
```

## The Solution

**Always use `--scope user` for personal tools:**

```bash
claude mcp add claude-self-reflect /path/to/server --scope user
```

## Why This Design?

Claude's project-specific configurations allow:
- Different MCP servers per project
- Project isolation for security
- Team sharing via `.mcp.json`

But the default `local` scope creates unexpected behavior for personal tools.

## Key Takeaways

1. **Default is `local`** - tied to exact directory
2. **Use `--scope user`** for personal tools you want everywhere
3. **MCP availability ≠ data scope** - claude-self-reflect searches ALL conversations regardless of where it's installed
4. **Check your scope** with `claude mcp list` - it shows the config location

## Debugging Commands

```bash
# See all MCP servers and their scopes
claude mcp list

# Check raw config
cat ~/.claude.json | jq '.mcpServers'  # User scope
cat ~/.claude.json | jq '.projects'     # Local scope configs
```