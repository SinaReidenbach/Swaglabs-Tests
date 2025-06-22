param (
    [bool]$DryRun = $false
)

$resultsRoot = if ($DryRun) { "resultsDryRun" } else { "results" }

Set-Location -Path $PSScriptRoot

.\.venv\Scripts\Activate.ps1

if (-not (Test-Path -Path $resultsRoot)) {
    New-Item -ItemType Directory -Path $resultsRoot | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$resultsPath = Join-Path $resultsRoot $timestamp
New-Item -ItemType Directory -Path $resultsPath | Out-Null

## Tests ausführen und Ergebnis in neuen Ordner speichern
robot --outputdir "$resultsPath" tests/

Write-Host "Tests wurden ausgeführt in: $resultsPath"
Start-Process "$resultsPath\log.html"


# Maximal 10 Ergebnisordner behalten, ältere löschen
$maxFolders = 10

$folders = Get-ChildItem $resultsRoot -Directory | Sort-Object LastWriteTime

if ($folders.Count -gt $maxFolders) {
    $toDelete = $folders.Count - $maxFolders
    $folders | Select-Object -First $toDelete | ForEach-Object {
        Remove-Item -Recurse -Force $_.FullName
        Write-Host "Gelöscht: $($_.FullName)"
    }
}
