# MCP Server Deployment naar Wix

## Voorbereiding
1. **Wix domein details:**
   - Hoofddomein: ?
   - Beschikbare subdomeinen: ?
   - Wix plan type: ? (voor hosting capabilities)

## Optie 1: Wix Velo Deployment

### Vereisten:
- Wix Premium plan met Velo
- Node.js serverless functions support

### Stappen:
1. Convert MCP server naar Wix Velo format
2. Deploy als web modules
3. Configure custom domain

## Optie 2: External Hosting op Subdomain

### Vereisten:
- Hosting provider (Vercel, Netlify, Railway)
- DNS configuratie toegang

### Voordelen:
- Volledige controle over server
- Eenvoudige deployment
- Automatische HTTPS

## Optie 3: Containerized Deployment

### Vereisten:
- Docker support
- Cloud hosting (Azure, AWS, Google Cloud)

## Huidige Server Aanpassingen Nodig:
- [ ] Environment variables voor productie
- [ ] HTTPS configuratie
- [ ] Domain-specific CORS settings
- [ ] Production logging
- [ ] Health check endpoints
