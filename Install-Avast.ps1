# Define the source (Update this to your internal storage or URL)
$sourcePath = "\\YourServer\Deploy\avast_business_antivirus_setup_offline.exe"
$localPath = "$env:TEMP\avast_setup.exe"

Write-Host "Copying Avast Installer..." -ForegroundColor Cyan
Copy-Item -Path $sourcePath -Destination $localPath

Write-Host "Installing Avast Business..." -ForegroundColor Green
# /silent for no UI, /rebootback for allowing restart if needed
Start-Process -FilePath $localPath -ArgumentList "/silent /no_reboot" -Wait
Remove-Item $localPath