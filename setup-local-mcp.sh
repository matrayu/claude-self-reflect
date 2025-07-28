#!/bin/bash
# Setup script for local claude-self-reflect MCP server installation

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MCP_SERVER_DIR="$SCRIPT_DIR/mcp-server"

echo "🚀 Setting up claude-self-reflect MCP server from local fork..."

# 1. Ensure Python dependencies are installed
echo "📦 Installing Python dependencies..."
cd "$MCP_SERVER_DIR"

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate and install dependencies
source venv/bin/activate
pip install -e . --quiet
pip install fastembed --quiet  # Ensure fastembed is installed

echo "✅ Dependencies installed"

# 2. Make run-mcp.sh executable
chmod +x "$MCP_SERVER_DIR/run-mcp.sh"

# 3. Add to Claude MCP
echo "🔧 Adding MCP server to Claude..."

# Save current directory
CURRENT_DIR=$(pwd)

# Change to a neutral directory to add globally
cd "$HOME"

# Remove any existing configuration
claude mcp remove claude-self-reflect 2>/dev/null || true

# Add the MCP server with user scope (available in all projects)
claude mcp add claude-self-reflect "$MCP_SERVER_DIR/run-mcp.sh" -e QDRANT_URL="http://localhost:6333" --scope user

# Return to original directory
cd "$CURRENT_DIR"

echo "✅ MCP server added to Claude"

# 4. Check Qdrant status
if curl -s http://localhost:6333/health > /dev/null 2>&1; then
    echo "✅ Qdrant is running"
else
    echo "⚠️  Qdrant is not running. Start it with: docker run -p 6333:6333 qdrant/qdrant"
fi

echo ""
echo "🎉 Setup complete! Restart Claude Code to use the MCP server."
echo ""
echo "📝 To use in other projects, run this script from any directory:"
echo "   $SCRIPT_DIR/setup-local-mcp.sh"