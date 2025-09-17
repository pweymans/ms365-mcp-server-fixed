# Test script for ngrok tunnel
Write-Host "=== Ngrok Tunnel Test Script ===" -ForegroundColor Green
Write-Host ""

# Instructions for user
Write-Host "STAP 1: Vind je ngrok URL" -ForegroundColor Yellow
Write-Host "Kijk in het ngrok terminal venster naar de 'Forwarding' regel" -ForegroundColor White
Write-Host "Kopieer de https://xxx.ngrok.io URL" -ForegroundColor White
Write-Host ""

Write-Host "STAP 2: Test je publieke URL" -ForegroundColor Yellow
Write-Host "Open je browser en ga naar: https://jouw-ngrok-url.ngrok.io" -ForegroundColor White
Write-Host "Je zou moeten zien: 'Microsoft 365 MCP Server is running'" -ForegroundColor White
Write-Host ""

Write-Host "STAP 3: Test het MCP endpoint" -ForegroundColor Yellow
Write-Host "MCP endpoint: https://jouw-ngrok-url.ngrok.io/mcp" -ForegroundColor White
Write-Host ""

Write-Host "STAP 4: Kopieer de URL voor ChatGPT-5 configuratie" -ForegroundColor Yellow
Write-Host "Bewaar deze URL voor de volgende stap!" -ForegroundColor White
Write-Host ""

# Wait for user input
Write-Host "Druk op Enter nadat je de ngrok URL hebt gekopieerd..." -ForegroundColor Cyan
Read-Host

# Ask for the ngrok URL
$ngrokUrl = Read-Host "Plak hier je ngrok URL (https://xxx.ngrok.io)"

if ($ngrokUrl) {
    Write-Host ""
    Write-Host "=== Testing je ngrok URL ===" -ForegroundColor Green
    
    try {
        $response = Invoke-WebRequest -Uri $ngrokUrl -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ SUCCESS: Server is publiek toegankelijk!" -ForegroundColor Green
            Write-Host "Response: $($response.Content)" -ForegroundColor White
            
            Write-Host ""
            Write-Host "Je MCP endpoint voor ChatGPT-5:" -ForegroundColor Yellow
            Write-Host "$ngrokUrl/mcp" -ForegroundColor Green
            
        } else {
            Write-Host "❌ ERROR: Unexpected response code: $($response.StatusCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ ERROR: Kan geen verbinding maken met $ngrokUrl" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Geen URL ingevoerd" -ForegroundColor Red
}

Write-Host ""
Write-Host "Volgende stap: Azure AD redirect URIs bijwerken met deze URL" -ForegroundColor Cyan
