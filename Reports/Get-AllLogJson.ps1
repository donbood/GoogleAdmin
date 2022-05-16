function Get-AllLogJson {

    $LogTypeArray = @("access_transparency", "admin", "calendar", "chat", "chrome", "context_aware_access", "data_studio", "drive", "gcp", "gplus", "groups", "groups_enterprise", "jamboard", "keep", "login", "meet", "mobile", "rules", "saml", "token", "user_accounts")

    foreach ($LogType in $LogTypeArray) {
        $TimeStamp = ((Get-Date).month, (Get-Date).day, (Get-Date).year) -join "_"
        $jsonFromPython = python .\fetchReports.py $LogType
    
        if ($jsonFromPython -eq "No logs found.") {
            Write-Host "No $Logtype logs found."
        }
        else {
            $jsonFromPython | Out-File -FilePath ".\adminLogs\$($LogType)$($TimeStamp).json"
        }
    }
}

Get-AllLogJson
Invoke-Item .\adminLogs
Set-Location .\adminLogs
