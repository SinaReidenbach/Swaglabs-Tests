if (-not (Test-Path -Path "results")) {
    New-Item -ItemType Directory -Path "results"
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$resultsPath = "results\$timestamp"
New-Item -ItemType Directory -Path $resultsPath

robot --output "$resultsPath/output.xml" --log "$resultsPath/log.html" --report "$resultsPath/report.html" tests/
