# Package.json Fix voor Vercel

## Huidige build script:
```json
"scripts": {
  "build": "tsup"
}
```

## Aangepaste build script:
```json
"scripts": {
  "build": "npm run generate && tsup",
  "generate": "node bin/generate-graph-client.mjs"
}
```

## Alternative: Vercel Build Settings
In Vercel Dashboard → Settings → Build & Development:
- Build Command: `npm run generate && npm run build`
- Output Directory: `dist`
- Install Command: `npm install`
