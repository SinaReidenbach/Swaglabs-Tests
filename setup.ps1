# setup.ps1

Write-Host "`n🚀 Projekt-Setup wird gestartet..." -ForegroundColor Cyan

# Schritt 1: Virtuelle Umgebung erstellen, falls nicht vorhanden
if (-not (Test-Path ".venv")) {
    Write-Host "⚙️ Erstelle virtuelle Umgebung..."
    python -m venv .venv
}

# Schritt 2: Virtuelle Umgebung aktivieren
Write-Host "⚙️ Aktiviere virtuelle Umgebung..."
. .\.venv\Scripts\Activate.ps1

# Schritt 3: Python-Abhängigkeiten installieren
if (Test-Path "requirements.txt") {
    Write-Host "`n📦 Installiere Python-Abhängigkeiten aus requirements.txt..."
    pip install -r requirements.txt
}
else {
    Write-Host "❗ requirements.txt nicht gefunden!"
}

# Schritt 4: Docker Desktop starten
Write-Host "`n🐳 Docker Desktop starten..."
$maxTries = 30
$tries = 0

while ($tries -lt $maxTries) {
    $dockerRunning = docker version --format '{{.Server.Version}}' 2>$null
    if ($dockerRunning) {
        Write-Output "✅ Docker läuft (Version: $dockerRunning)"
        break
    }
    else {
        Write-Output "⏳ Warte auf Docker... ($tries)"
        Start-Sleep -Seconds 2
        $tries++
    }
}

if (-not $dockerRunning) {
    Write-Output "❌ Docker konnte nicht innerhalb der erwarteten Zeit gestartet werden."
}

# Schritt 5: Docker Container starten
Write-Host "`n🐳 Starte Docker-Container (MySQL & phpMyAdmin)..."
docker-compose -f ./docker/docker-compose.yml up -d

# Schritt 6: Warte optional, bis MySQL wirklich erreichbar ist
Write-Host "`n⏳ Warte auf Datenbankverfügbarkeit..."
Start-Sleep -Seconds 10

# Schritt 7: Ausgabe der Zugänge
Write-Host "`n✅ Setup abgeschlossen!"
Write-Host "Datenbank läuft auf:     localhost:3306"
Write-Host "phpMyAdmin erreichbar:   http://localhost:8080"
Write-Host "Benutzername:            swaguser"
Write-Host "Passwort:                swagpass"

# Schritt 8: Hinweis auf Teststart
Write-Host "`n📄 Starte Tests mit: .\run_tests.ps1" -ForegroundColor Green
