function Get-Reports {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("access_transparency", "admin", "calendar", "chat", "chrome", "context_aware_access", "data_studio", "drive", "gcp", "gplus", "groups", "groups_enterprise", "jamboard", "keep", "login", "meet", "mobile", "rules", "saml", "token", "user_accounts")]
        $LogType
    )

    $Reports = ""

    if ($PSBoundParameters.Containskey("LogType")) {
        $jsonFromPython = python .\fetchReports.py $LogType

        if ($jsonFromPython -eq "No logs found.") {
            Write-Host "No logs found."
        }
        else {
            $Reports = $jsonFromPython | ConvertFrom-Json
        }
    }
    else {
        $jsonFromPython = python .\fetchReports.py admin

        if ($jsonFromPython -eq "No logs found.") {
            Write-Host "No logs found."
        }
        else {
            $Reports = $jsonFromPython | ConvertFrom-Json
        }
    }

    if ($Reports -ne "") {
        $outputArray = @()
    
        
        foreach ($report in $Reports) {
            $eventDescArray = @()
            $events = $report.events
            foreach ($event in $events) {
            
                $EventParams = $event.parameters
    
                $paramArray = @()
                foreach ($eventParam in $EventParams) {
                    $paramObj = [pscustomobject] @{
                        paramName  = $eventParam.name
                        paramValue = $eventParam.value
                    }
                    $paramArray += $paramObj
                }
    
                foreach ($paramObj in $paramArray) {
                    $strang = "$($ParamObj.ParamName): $($ParamObj.ParamValue)"
                    $eventDescArray += $strang
                }
    
        
            }

            $time = $report.id.time
            $datetime = ([DateTime]$time).ToUniversalTime()
            $EST = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($datetime, 'Eastern Standard Time')
            $eventObj = [pscustomobject] @{
                Date  = $EST.toString()
                Actor = $report.actor.email
                Event = $report.events.name
                Type  = $report.events.type
                Desc  = $eventDescArray -join "|"
            }
            $outputArray += $eventObj
        }
    
        $outputArray | Export-Csv ".\AdminReportLog-$($LogType).csv" -NoTypeInformation
        $outputArray
    }
}
