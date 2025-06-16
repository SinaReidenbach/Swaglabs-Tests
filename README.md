# Projekt Setup Anleitung

Diese Anleitung beschreibt die notwendigen Schritte und Voraussetzungen, um das Projekt lokal einzurichten und lauffähig zu machen.
<br><br>

## 1  Voraussetzungen

### 1.1   Systemanforderungen

- Betriebssystem: Windows 10 oder höher
- Windows-Subsystem für Linux (WSL) Version 2 (empfohlen)
- PowerShell 7 oder höher
- Git

### 1.2   Installierte Software

- [Docker Desktop](https://www.docker.com/products/docker-desktop) (inkl. Docker Engine)
- WSL 2 (für Windows-Nutzer empfohlen)
- Python 3.8 oder höher
- MySQL Server (wird als Docker Container betrieben)
- phpMyAdmin (wird als Docker Container betrieben)
<br><br>

## 2   Setup

### 2.1   Automatisiertes Setup
Ein PowerShell-Skript mit dem Namen setup.ps1 befindet sich im Projektverzeichnis. Es übernimmt folgende Aufgaben:

- Start von Docker Desktop (sofern nicht bereits aktiv)
- Ausführung von docker-compose zur Bereitstellung der Datenbank und phpMyAdmin
- Installation der Python-Abhängigkeiten aus der Datei requirements.txt (sofern noch nicht vorhanden)

#### 2.1.1   Ausführung über die PowerShell:

```bash
.\setup.ps1
```

### 2.2  Manuelles Setup (alternativ zum Setup-Skript)

#### 2.2.1    Erforderliche Bibliotheken

- robotframework
- robotframework-seleniumlibrary
- selenium
- mysql-connector-python

#### 2.2.2  Projektabhängigkeiten

Die Python-Abhängigkeiten werden mit `pip` über die `requirements.txt` installiert.

#### 2.2.3   Ausführung über die PowerShell:

```bash
pip install -r requirements.txt
```


### 2.3  Docker Setup

Die im Projekt enthaltene docker-compose.yml definiert zwei Services:

- swaglabs-db: MySQL Datenbank (Version 8)
- swaglabs-pma: phpMyAdmin Webinterface

#### 2.3.1 Container manuell starten:

```bash
docker-compose -f ./docker/docker-compose.yml up -d
```

### 2.4  Datenbank Setup

#### 2.4.1   Datenbankkonfiguration

- Host: localhost
- Port: 3306
- Benutzer: swaguser
- Passwort: swagpass
- Datenbank: swaglabs

#### 2.4.2   phpMyAdmin

- Erreichbar unter: http://localhost:8080
- Zugangsdaten wie oben aufgeführt
<br><br>

## 3 Testausführung

### 3.1  Teststart

Für die Ausführung der Tests steht das PowerShell-Skript run_tests.ps1 zur Verfügung. Dabei werden die Testergebnisse, inklusive Logdateien und Screenshots, in einem automatisch erstellten Zeitstempel-Ordner im Verzeichnis results gespeichert. Ältere Testverzeichnisse werden automatisch entfernt, sobald mehr als zehn vorhanden sind.

#### 3.1.1   Ausführung über die PowerShell:

```bash
robot --output results/<timestamp>/output.xml --log results/<timestamp>/log.html --report results/<timestamp>/report.html tests/
```
<br>

## 4 Hinweise

- Der Port 3306 sollte nicht von anderen Anwendungen belegt sein.
- Docker Desktop und WSL sollten vor der Verwendung gestartet bzw. verfügbar sein.
- Für den Zugriff auf die Datenbank wurden eigene SQL-Keywords innerhalb von Robot Framework implementiert. Eine externe Bibliothek wie DatabaseLibrary wird nicht verwendet.
