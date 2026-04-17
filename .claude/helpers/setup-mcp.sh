#!/bin/bash
# Setup MCP server for FidgetFlo

echo "🚀 Setting up FidgetFlo MCP server..."

# Check if claude command exists
if ! command -v claude &> /dev/null; then
    echo "❌ Error: Claude Code CLI not found"
    echo "Please install Claude Code first"
    exit 1
fi

# Add MCP server
echo "📦 Adding FidgetFlo MCP server..."
claude mcp add fidgetflo npx fidgetflo mcp start

echo "✅ MCP server setup complete!"
echo "🎯 You can now use mcp__fidgetflo__ tools in Claude Code"
