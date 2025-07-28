# Local Fork - Important Fixes

This fork contains critical fixes not yet in the upstream repository:

## Critical Fixes Applied

### 1. ScoredPoint Bug Fix (Fixed in server.py)
- **Issue**: "ScoredPoint" object has no field "search_query"
- **Fix**: Changed `results.points` to `results` when iterating over Qdrant query_points response
- **Files Modified**: `mcp-server/src/server.py` (lines 240, 301)

### 2. Missing Dependencies
- **Issue**: fastembed not included in requirements
- **Fix**: Added to installation script
- **Action Needed**: Update requirements.txt and pyproject.toml

## Installation for Other Local Projects

### Option 1: Quick Setup (Recommended)
```bash
# From any Claude project directory:
/Users/matrayu/Projects/claude-self-reflect/setup-local-mcp.sh
```

### Option 2: Manual Setup
```bash
# Add MCP server pointing to this fork
claude mcp add claude-self-reflect "/Users/matrayu/Projects/claude-self-reflect/mcp-server/run-mcp.sh" -e QDRANT_URL="http://localhost:6333"

# Restart Claude Code
```

### Option 3: Symlink Approach
```bash
# Create a symlink in a directory that's in your PATH
ln -s /Users/matrayu/Projects/claude-self-reflect/setup-local-mcp.sh /usr/local/bin/setup-claude-reflect

# Then from any project:
setup-claude-reflect
```

## Why Use This Fork?

1. **Working Search**: Upstream has broken search functionality
2. **Local Control**: No dependency on npm registry
3. **Easy Updates**: Pull upstream changes and reapply fixes
4. **Consistent Setup**: Same working version across all projects

## Keeping Fork Updated

```bash
# Add upstream remote (one time)
git remote add upstream https://github.com/ramakay/claude-self-reflect.git

# Update fork with upstream changes
git fetch upstream
git checkout main
git merge upstream/main

# Reapply critical fixes if needed
# The ScoredPoint fix is in mcp-server/src/server.py
```

## Known Working Configuration

- Python 3.12
- FastMCP 2.10.6
- Qdrant Client 1.15.0
- Virtual environment in mcp-server/venv
- Qdrant running on localhost:6333