# Ensure TLS 1.2 for Windows Server 2016 compatibility
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url = "https://dl.google.com/chrome/install/latest/googlechromestandaloneenterprise64.msi"
$output = "$env:TEMP\ChromeInstaller.msi"

Write-Host "Downloading Google Chrome..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $output

Write-Host "Installing Google Chrome..." -ForegroundColor Green
$process = Start-Process msiexec.exe -ArgumentList "/i `"$output`" /qn /norestart /l*v `"$env:TEMP\chrome_install.log`"" -Wait -PassThru

if ($process.ExitCode -eq 0) { Write-Host "Success" } else { Write-Error "Install failed with code $($process.ExitCode)" }
Remove-Item $output