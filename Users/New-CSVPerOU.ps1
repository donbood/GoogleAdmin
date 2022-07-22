# Takes all the users from the .\Get-OrgUnits.ps1 script and outputs a csv of users for each OU in the tenant.

$users = .\Get-Users.ps1
$orgUnits = $users | select-object -ExpandProperty orgUnit -Unique

foreach($ou in $orgUnits) {
    $ouNameForFile = $ou -replace "/", "_"
    $users | Where-Object -FilterScript {$_.orgUnit -eq "$($ou)"} | Export-Csv ".\users_$($ouNameForFile).csv" -NoTypeInformation
}
