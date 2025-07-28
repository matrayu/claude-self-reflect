#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const configPath = path.join(os.homedir(), '.claude.json');

console.log('🔧 Fixing Claude MCP configuration for global access...\n');

try {
    // Read current config
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    
    // Find all project-specific claude-self-reflect entries
    let found = false;
    
    // Check if there's a global mcpServers section
    if (!config.mcpServers) {
        config.mcpServers = {};
    }
    
    // Look for claude-self-reflect in project-specific configs
    for (const [projectPath, projectConfig] of Object.entries(config.projects || {})) {
        if (projectConfig.mcpServers && projectConfig.mcpServers['claude-self-reflect']) {
            console.log(`Found claude-self-reflect in project: ${projectPath}`);
            
            // Copy to global config
            config.mcpServers['claude-self-reflect'] = projectConfig.mcpServers['claude-self-reflect'];
            
            // Remove from project config
            delete projectConfig.mcpServers['claude-self-reflect'];
            
            // Clean up empty mcpServers object
            if (Object.keys(projectConfig.mcpServers).length === 0) {
                delete projectConfig.mcpServers;
            }
            
            found = true;
        }
    }
    
    if (found) {
        // Write updated config
        fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
        console.log('✅ Moved claude-self-reflect to global configuration!');
        console.log('🎉 The MCP server is now available in ALL projects.');
        console.log('\n🔄 Please restart Claude Code for changes to take effect.');
    } else {
        console.log('❌ No claude-self-reflect MCP server found in any project configuration.');
        console.log('   Please run setup-local-mcp.sh first.');
    }
    
} catch (error) {
    console.error('Error modifying Claude config:', error.message);
}