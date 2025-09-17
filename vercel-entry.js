// Vercel Entry Point for MS365 MCP Server
import 'dotenv/config';
import express from 'express';
import AuthManager, { buildScopesFromEndpoints } from './dist/auth.js';
import { registerAuthTools } from './dist/auth-tools.js';
import { registerGraphTools } from './dist/graph-tools.js';
import GraphClient from './dist/graph-client.js';
import { MicrosoftOAuthProvider } from './dist/oauth-provider.js';
import { microsoftBearerTokenAuthMiddleware } from './dist/lib/microsoft-auth.js';
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';

// Initialize once
let app = null;
let initialized = false;

async function initializeApp() {
  if (initialized) return app;

  const includeWorkScopes = process.env.MS365_MCP_ORG_MODE === 'true';
  const scopes = buildScopesFromEndpoints(includeWorkScopes);
  const authManager = new AuthManager(undefined, scopes);
  await authManager.loadTokenCache();

  const graphClient = new GraphClient(authManager);
  
  // Create MCP Server
  const server = new McpServer({
    name: 'Microsoft365MCP',
    version: '1.0.0',
  });

  // Register tools
  const shouldRegisterAuthTools = process.env.ENABLE_AUTH_TOOLS === 'true';
  if (shouldRegisterAuthTools) {
    registerAuthTools(server, authManager);
  }
  registerGraphTools(server, graphClient);

  // Create Express app
  app = express();
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // CORS
  app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.header(
      'Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept, Authorization, mcp-protocol-version'
    );
    if (req.method === 'OPTIONS') {
      res.sendStatus(200);
      return;
    }
    next();
  });

  // Basic health check
  app.get('/', (req, res) => {
    res.send('Microsoft 365 MCP Server is running');
  });

  // Discovery endpoint
  app.get('/mcp/discovery', (req, res) => {
    const url = new URL(`${req.protocol}://${req.get('host')}`);
    res.json({
      name: 'Microsoft365MCP',
      version: '1.0.0',
      description: 'Microsoft 365 MCP Server for accessing Graph API',
      mcp_endpoint: `${url.origin}/mcp`,
      authentication: {
        type: 'oauth2',
        oauth_endpoints: {
          authorization_url: `https://login.microsoftonline.com/common/oauth2/v2.0/authorize`,
          token_url: `https://login.microsoftonline.com/common/oauth2/v2.0/token`
        }
      },
      capabilities: ['tools', 'resources'],
      tools_available: ['get-current-user', 'list-mail-messages', 'send-mail', 'list-calendars', 'list-calendar-events']
    });
  });

  // MCP endpoint with auth
  app.all('/mcp', microsoftBearerTokenAuthMiddleware, async (req, res) => {
    try {
      const transport = new StreamableHTTPServerTransport({
        sessionIdGenerator: undefined,
      });

      res.on('close', () => {
        transport.close();
      });

      await server.connect(transport);
      await transport.handleRequest(req, res, undefined);
    } catch (error) {
      console.error('MCP error:', error);
      if (!res.headersSent) {
        res.status(500).json({
          jsonrpc: '2.0',
          error: { code: -32603, message: 'Internal server error' },
          id: null,
        });
      }
    }
  });

  initialized = true;
  return app;
}

export default async function handler(req, res) {
  try {
    const expressApp = await initializeApp();
    return expressApp(req, res);
  } catch (error) {
    console.error('Vercel handler error:', error);
    res.status(500).json({ error: 'Server initialization failed' });
  }
}
