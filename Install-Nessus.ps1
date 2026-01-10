[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Note: Tenable links update frequently; ensure this direct link is active
$url = "https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-latest-x64.msi"
$output = "$env:TEMP\NessusInstaller.msi"

Invoke-WebRequest -Uri $url -OutFile $output
Write-Host "Installing Nessus..." -ForegroundColor Green
Start-Process msiexec.exe -ArgumentList "/i `"$output`" /qn /norestart" -Wait
Remove-Item $output