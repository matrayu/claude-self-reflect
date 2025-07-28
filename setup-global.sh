#!/bin/bash
# Setup script to add claude-self-reflect MCP server globally

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MCP_SERVER_DIR="$SCRIPT_DIR/mcp-server"

echo "🚀 Setting up claude-self-reflect MCP server globally..."

# 1. Ensure dependencies are installed
echo "📦 Checking Python dependencies..."
cd "$MCP_SERVER_DIR"

if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -e . --quiet
    pip install fastembed --quiet
else
    echo "✅ Virtual environment already exists"
fi

cd "$HOME"

# 2. Add MCP server globally
echo "🔧 Adding MCP server globally..."

# Remove from all configurations first
claude mcp remove claude-self-reflect 2>/dev/null || true

# Add globally by running from home directory
claude mcp add claude-self-reflect "$MCP_SERVER_DIR/run-mcp.sh" -e QDRANT_URL="http://localhost:6333" --global

echo "✅ MCP server added globally"

# 3. Check status
echo ""
echo "📋 Current MCP servers:"
claude mcp list

echo ""
echo "🎉 Setup complete! The MCP server is now available in all Claude projects."
echo "🔄 Restart Claude Code in any project to use it."