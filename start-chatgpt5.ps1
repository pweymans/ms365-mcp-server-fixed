# Start MS365 MCP Server for ChatGPT-5 Developer Mode
Write-Host "🚀 Starting MS365 MCP Server for ChatGPT-5..." -ForegroundColor Green

# Load environment variables for ChatGPT-5 configuration
if (Test-Path "chatgpt5-config.env") {
    Write-Host "📄 Loading ChatGPT-5 configuration..." -ForegroundColor Yellow
    Get-Content "chatgpt5-config.env" | ForEach-Object {
        if ($_ -match "^([^#=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

# Set required environment variables
$env:MS365_MCP_ORG_MODE = "true"
$env:ENABLE_AUTH_TOOLS = "true"

Write-Host "🌐 Starting server in HTTP mode for external access..." -ForegroundColor Cyan
Write-Host "📍 Server will be available at: http://localhost:3000" -ForegroundColor White
Write-Host "🔗 MCP endpoint: http://localhost:3000/mcp" -ForegroundColor White
Write-Host "" 
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Install ngrok: winget install ngrok" -ForegroundColor White
Write-Host "2. Create tunnel: ngrok http 3000" -ForegroundColor White
Write-Host "3. Update Azure AD redirect URIs with ngrok URL" -ForegroundColor White
Write-Host "4. Configure ChatGPT-5 Developer Mode with the ngrok MCP endpoint" -ForegroundColor White
Write-Host ""

# Start the server
npx tsx src/index.ts --http 3000 --org-mode --enable-auth-tools -v
