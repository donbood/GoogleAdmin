Write-Host "Running the Python Script to Get All The Users returned as JSON string... Can take like a min..."
$jsonFromPython = python .\fetchUsers.py

if($jsonFromPython -eq "No users in the domain.") {
    Write-Host "No users in the domain."
} else {
    $outputArray = @()
    Write-Host "Converting Python-provided JSON string to Powershell Object"
    $users = $jsonFromPython | ConvertFrom-Json

    Write-Host "Converting Raw Powershell Object to Custom Powershell Object per user..."
    foreach ($user in $users) {
       $userObject = [PSCustomObject] @{
        creationTime = $user.creationTime
        lastLoginTime = $user.lastLoginTime
        email = $user.primaryEmail   
        lastName = $user.name.familyName
        firstName = $user.name.givenName
        orgUnit = $user.orgUnitPath
        admin = $user.isAdmin
        delegatedAdmin = $user.isDelegatedAdmin
        enrolledIn2FA = $user.isEnrolledin2Sv
        enforced2FA = $user.isEnforcedIn2Sv
        archived = $user.archived
        mailboxSetup = $user.isMailboxSetup
        suspended = $user.suspended
        suspensionReason = $user.suspensionReason
        kind = $user.kind
       }
       Write-Host "Added accessible object for $($user.primaryEmail)"
       $outputArray += $userObject
   }
}

Write-Host "Outputting to CSV"
$outputArray | Export-Csv -Path .\GoogleUsersOutput.csv -NoTypeInformation
Write-Host "CSV Complete" -BackgroundColor Green