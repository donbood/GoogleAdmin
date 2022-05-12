#Get the Admin logs from your PSGSuite Instance for the last 30 days and output to CSV.
#Requires you to authenticate with PSGSuite. If you are not already a PSGSuite User, this script will not work for you at all.

$outputArray = @()

$logsLast30Days = Get-GSActivityReport -StartTime (Get-Date).AddDays(-30)

foreach($log in $logsLast30Days) {


    $LogActor = $log.actor.Email
    $LogTime = $log.Id.Time
    $LogEvents = $log.Events
    $eventArray = @()

    foreach($event in $LogEvents) {
        $eventArray += $event.Name
    }

    $OutputObject = [pscustomobject] @{
      
        Actor = $LogActor
        Timestamp = $LogTime
        Events = $eventArray -join ","
        Kind = $log.kind
        Etag = $log.ETag

    } 

        $outputArray += $OutputObject

}

$outputArray | Export-CSV -Path .\GSLogsLast30Days -NoTypeInformation
