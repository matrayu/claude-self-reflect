#!/bin/bash
# Setup script to add claude-self-reflect MCP server to current project

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MCP_SERVER_DIR="$SCRIPT_DIR/mcp-server"

echo "🚀 Setting up claude-self-reflect MCP server for current project..."
echo "📍 Current project: $(pwd)"

# 1. Ensure dependencies are installed in the MCP server
echo "📦 Checking Python dependencies..."
cd "$MCP_SERVER_DIR"

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -e . --quiet
    pip install fastembed --quiet
else
    echo "✅ Virtual environment already exists"
fi

# Return to project directory
cd - > /dev/null

# 2. Add MCP server to current project
echo "🔧 Adding MCP server to current project..."

# This adds it to the project-specific configuration
claude mcp remove claude-self-reflect 2>/dev/null || true
claude mcp add claude-self-reflect "$MCP_SERVER_DIR/run-mcp.sh" -e QDRANT_URL="http://localhost:6333"

echo "✅ MCP server added to current project"

# 3. Check Qdrant status
if curl -s http://localhost:6333/health > /dev/null 2>&1; then
    echo "✅ Qdrant is running"
else
    echo "⚠️  Qdrant is not running. Start it with: docker run -p 6333:6333 qdrant/qdrant"
fi

echo ""
echo "🎉 Setup complete for $(pwd)"
echo "🔄 Please restart Claude Code or run: /restart"
echo ""
echo "📝 Test with: /mcp"