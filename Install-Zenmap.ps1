[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://nmap.org/dist/nmap-7.95-setup.exe"
$output = "$env:TEMP\nmap-setup.exe"

Invoke-WebRequest -Uri $url -OutFile $output
Write-Host "Installing Zenmap/Nmap..." -ForegroundColor Green
# /S for Silent, /D to specify directory (optional)
Start-Process -FilePath $output -ArgumentList "/S" -Wait
Remove-Item $output