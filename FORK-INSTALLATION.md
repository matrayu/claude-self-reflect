# Installing from This Fork

This fork contains critical fixes for the claude-self-reflect MCP server. Here's how to install it on any machine.

## Quick Install (From GitHub)

### 1. Clone the fork
```bash
git clone https://github.com/matrayu/claude-self-reflect.git
cd claude-self-reflect
```

### 2. Setup MCP Server

#### Recommended: Global Installation (All Projects)
```bash
# Run from anywhere - uses --scope user flag
/path/to/claude-self-reflect/setup-local-mcp.sh
```
This installs with `--scope user` making it available in ALL your projects.

#### Alternative: Single Project Only
```bash
# Navigate to your project directory first
cd /path/to/your/project
# Run the project setup script
/path/to/claude-self-reflect/setup-for-project.sh
```

### 3. Restart Claude Code

### Understanding MCP Scopes

Claude MCP has three scope options:
- **`user`** - Available in all your projects (recommended for personal tools)
- **`local`** - Only in the current project directory (default if no scope specified)
- **`project`** - Shared via .mcp.json file in the project

The confusion earlier was that without `--scope user`, the MCP was being installed as `local` scope tied to wherever you ran the command from.

## Manual Installation

### 1. Clone and setup Python environment
```bash
git clone https://github.com/matrayu/claude-self-reflect.git
cd claude-self-reflect/mcp-server

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -e .
pip install fastembed  # Critical dependency
```

### 2. Add to Claude
```bash
claude mcp add claude-self-reflect "/full/path/to/claude-self-reflect/mcp-server/run-mcp.sh" -e QDRANT_URL="http://localhost:6333"
```

### 3. Start Qdrant (if not running)
```bash
docker run -p 6333:6333 qdrant/qdrant
```

## Why Use This Fork?

### Critical Fixes Included:
1. **ScoredPoint Bug Fix**: Fixes "ScoredPoint object has no field search_query" error
2. **Missing Dependencies**: Includes fastembed in requirements
3. **Easy Setup Script**: Automated installation process

### Upstream Issues:
- npm package (v2.4.1) has broken search functionality
- Missing fastembed dependency causes import errors
- Complex virtual environment setup

## Updating This Fork

```bash
# Add upstream remote (first time only)
git remote add upstream https://github.com/ramakay/claude-self-reflect.git

# Update from upstream
git fetch upstream
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

## Installation on Multiple Machines

Once pushed to GitHub, you can install on any machine:

```bash
# Quick one-liner
git clone https://github.com/matrayu/claude-self-reflect.git && cd claude-self-reflect && ./setup-local-mcp.sh
```

## Verification

After installation, test the MCP tools in Claude:
1. Open/restart Claude Code
2. Test search: The reflection tool should work without errors
3. Test storage: Store a reflection to verify write access

## Troubleshooting

### "No such tool available" error
- Restart Claude Code after installation
- Check: `claude mcp list` should show claude-self-reflect as connected

### "ModuleNotFoundError: fastembed"
- Activate the correct venv: `source mcp-server/venv/bin/activate`
- Install: `pip install fastembed`

### Search returns no results
- Ensure Qdrant is running: `docker ps | grep qdrant`
- Import conversations using the import scripts