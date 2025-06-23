Get-CimInstance Win32_Process |
Where-Object { $_.Name -like "python*" -and $_.CommandLine -match "\\.venv\\" } |
ForEach-Object {
    Write-Host "Beende PID $($_.ProcessId): $($_.CommandLine)"
    Stop-Process -Id $_.ProcessId -Force
}

if (Test-Path .\.venv) {
    Remove-Item -Recurse -Force .\.venv
}
