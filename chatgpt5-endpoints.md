# ChatGPT-5 MCP Server Endpoints

## Je Publieke URLs (via ngrok)
- **Base URL:** https://c8534d63ab0e.ngrok-free.app
- **MCP Endpoint:** https://c8534d63ab0e.ngrok-free.app/mcp
- **OAuth Authorization:** https://c8534d63ab0e.ngrok-free.app/auth/authorize
- **OAuth Token:** https://c8534d63ab0e.ngrok-free.app/auth/token
- **OAuth Discovery:** https://c8534d63ab0e.ngrok-free.app/.well-known/oauth-authorization-server

## Voor Azure AD Configuration
Voeg deze Redirect URIs toe in je Azure AD app:
```
https://c8534d63ab0e.ngrok-free.app/auth/callback
https://chatgpt.com/oauth/callback
https://chat.openai.com/oauth/callback
```

## Voor ChatGPT-5 Developer Mode
- **MCP Server URL:** `https://c8534d63ab0e.ngrok-free.app/mcp`
- **Authentication Type:** OAuth 2.0
- **OAuth Endpoints:**
  - Authorization URL: `https://login.microsoftonline.com/common/oauth2/v2.0/authorize`
  - Token URL: `https://login.microsoftonline.com/common/oauth2/v2.0/token`

## Testing URLs
- **Server Status:** https://c8534d63ab0e.ngrok-free.app (should show "Microsoft 365 MCP Server is running")
- **OAuth Discovery:** https://c8534d63ab0e.ngrok-free.app/.well-known/oauth-authorization-server
