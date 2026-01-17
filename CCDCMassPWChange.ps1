# CCDC Rapid Reset & Canary Detection
Import-Module ActiveDirectory

$excludedUsers = @("krbtgt", "gold-team", "scoring", "BTA", "Timmy")
# CCDC usually starts with a "Golden Image." 
# This checks for ANY user created in the last 2 hours (the start of the competition).
$startTime = (Get-Date).AddHours(-2) 

function Get-RandomPassword {
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+"
    return -join (1..16 | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

$results = @()
$canaries = @()

# Get all users with the 'whenCreated' property
$allUsers = Get-ADUser -Filter * -Properties whenCreated | Where-Object { $excludedUsers -notcontains $_.SamAccountName }

foreach ($user in $allUsers) {
    $pass = Get-RandomPassword
    $isNew = $user.whenCreated -gt $startTime
    
    try {
        Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword (ConvertTo-SecureString -AsPlainText $pass -Force) -ErrorAction Stop
        Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true
        
        $results += [PSCustomObject]@{
            User    = $user.SamAccountName
            Pass    = $pass
            Status  = if ($isNew) { "!! NEW !!" } else { "OK" }
        }
        
        if ($isNew) { $canaries += $user.SamAccountName }
    } catch {
        Write-Warning "Failed to reset: $($user.SamAccountName)"
    }
}

# Clear screen and display final table for Host-Machine Screenshot
cls
Write-Host "--- CCDC CREDENTIALS (SNAPSHOT NOW) ---" -ForegroundColor Cyan
$results | Format-Table -AutoSize

if ($canaries.Count -gt 0) {
    Write-Host "`n[!] ATTENTION: Suspicious accounts detected (Created after competition start):" -ForegroundColor Red
    $canaries | ForEach-Object { Write-Host " -> $_" -ForegroundColor Red }
}

# Wait for you to signal that you've snapped the picture
Read-Host "`nPress Enter once you have your screenshot to wipe the session"

# Wipe traces
Clear-Host
Remove-Variable * -ErrorAction SilentlyContinue
[Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()