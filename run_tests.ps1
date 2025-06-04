if (-not (Test-Path -Path "results")) {
    New-Item -ItemType Directory -Path "results"
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$resultsPath = "$resultsRoot\$timestamp"
New-Item -ItemType Directory -Path $resultsPath | Out-Null

robot --output "$resultsPath/output.xml" --log "$resultsPath/log.html" --report "$resultsPath/report.html" tests/
Write-Host "Tests wurden ausgeführt in: $resultsPath"
Start-Process "$resultsPath\log.html"

$maxFolders = 10
$resultsRoot = "results"

$folders = Get-ChildItem $resultsRoot -Directory | Sort-Object LastWriteTime

if ($folders.Count -gt $maxFolders) {
    $toDelete = $folders.Count - $maxFolders
    $folders | Select-Object -First $toDelete | ForEach-Object {
        Remove-Item -Recurse -Force $_.FullName
    }
}
