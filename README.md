# Projekt Setup Anleitung

Diese Anleitung beschreibt die notwendigen Schritte und Voraussetzungen, um das Projekt lokal einzurichten und lauffähig zu machen.
<br><br>

## 1  Voraussetzungen (manuell zu installieren)

### 1.1  Systemanforderungen

- Firefox: 140.0.2
- Betriebssystem: Windows 10 oder höher
- PowerShell 7 oder höher
- Windows-Subsystem für Linux (WSL) Version 2 (empfohlen)
- Git (für Versionskontrolle)


### 1.2  Benötigte Software

Vor dem automatischen Setup müssen folgende Programme manuell installiert sein:

- Python 3.11.9 (oder höher)
- VSCode: 1.101.2 mit Robocorp Extension 1.13.0
- Docker Desktop 28.2.2
- WSL: Version 2
- geckodriver: 0.36.0

## 2   Setup
Ein PowerShell-Skript mit dem Namen setup.ps1 befindet sich im Projektverzeichnis. Es übernimmt folgende Aufgaben:

### 2.1  Virtuelle Umgebung erstellen

```pwsh
    python -m venv .venv
```

### 2.2  Virtuelle Umgebung aktivieren
```pwsh
    . .\.venv\Scripts\Activate.ps1
```

### 2.3  Python-Abhängigkeiten installieren
```pwsh
    pip install -r requirements.txt
```

#### 2.3.1  zu installierende Abhängigkeiten

Die nachfolgenden Tool-Versionen wurden beim Projekt-Setup verwendet und getestet (Stand: Juni 2025):

- Robot Framework: 7.3.1
- SeleniumLibrary: 6.7.1
- Selenium: 4.21.0
- mysql-connector-python: 9.3.0
- Robocop: 3.4.0
- MySQL (Docker): 8.2.27
- phpMyAdmin (Docker): 5.2.2

### 2.4  "Docker Desktop" starten
```pwsh
    $dockerPath = Join-Path $env:ProgramFiles "Docker\Docker\Docker Desktop.exe"
    Start-Process $dockerPath
```

### 2.5  Docker Container starten
```pwsh
    docker-compose -f ./docker/docker-compose.yml up -d
```

#### 2.5.1   phpMyAdmin

- Erreichbar unter: http://localhost:8080
- Zugangsdaten wie oben aufgeführt

#### 2.5.2   Datenbankkonfiguration

- Host: localhost
- Port: 3306
- Benutzer: swaguser
- Passwort: ********
- Datenbank: swaglabs

### 2.6  Tabelle in DB erstellen
```pwsh
    python '.\db\create_purchase.py'
```
<br><br>

## 3 Testausführung

### 3.1  Teststart

Für die Ausführung der Tests steht das PowerShell-Skript run_tests.ps1 zur Verfügung. Dabei werden die Testergebnisse, inklusive Logdateien und Screenshots, in einem automatisch erstellten Zeitstempel-Ordner im Verzeichnis results gespeichert. Ältere Testverzeichnisse werden automatisch entfernt, sobald mehr als zehn vorhanden sind.

#### 3.1.1   Ausführung über die PowerShell:

```pwsh
$resultsPath=results
robot --outputdir "$resultsPath" tests/
```
Alternative, um gezielt die einzelnen Tests anzusprechen
```pwsh
robot --outputdir "$resultsPath" --include login    tests/
robot --outputdir "$resultsPath" --include purchase tests/
```
<br>

## 4 Hinweise

- Der Port 3306 darf nicht von anderen Anwendungen belegt sein.
- Docker Desktop und WSL müssen vor der Verwendung gestartet bzw. verfügbar sein.
- Für den Zugriff auf die Datenbank wurden eigene SQL-Keywords innerhalb von Robot Framework implementiert.
- Eine externe Bibliothek wie DatabaseLibrary wird nicht verwendet.
- MySQL Server und phpMyAdmin werden im Projekt als Docker-Container bereitgestellt und müssen nicht separat installiert werden.
