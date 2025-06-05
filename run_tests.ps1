$resultsRoot = "results"

if (-not (Test-Path -Path $resultsRoot)) {
    New-Item -ItemType Directory -Path $resultsRoot | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$resultsPath = Join-Path $resultsRoot $timestamp
New-Item -ItemType Directory -Path $resultsPath | Out-Null

# Tests ausführen und Ergebnis in neuen Ordner speichern
robot --output "$resultsPath/output.xml" --log "$resultsPath/log.html" --report "$resultsPath/report.html" tests/

Write-Host "Tests wurden ausgeführt in: $resultsPath"
Start-Process "$resultsPath\log.html"

# Nur selenium-screenshot Dateien direkt im results Root Ordner finden (keine Unterordner)
$screenshotFiles = Get-ChildItem $resultsRoot -Filter "selenium-screenshot*.*" -File | Where-Object {
    $_.DirectoryName -eq (Resolve-Path $resultsRoot).Path
}

foreach ($file in $screenshotFiles) {
    $destination = Join-Path $resultsPath $file.Name
    Move-Item -Path $file.FullName -Destination $destination -Force
    Write-Host "Verschoben: $($file.FullName)"
}

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
