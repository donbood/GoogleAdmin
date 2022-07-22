$users = .\Get-Users.ps1

function format-OU {
    [CmdletBinding()]
    param (
        [Parameter()]
        $ou
    )

    $base = "" # add your base

    if($ou.Length -gt 1) {
        $array = $ou -split '/'
        [array]::reverse($array)
        $output = @()
        $output += ($array | Select-Object -SkipLast 1) -replace '^.*$', 'OU=$0'
        $output = $output -join ','
        $output += ",$($base)"
    } elseif ($ou -eq "/") {
        $output = $base
    }

    return $output
}

$users | 
select-object *, 
@{N ="Name";E = {"$($_.firstname) $($_.lastName)"}}, 
@{N ="GivenName";E = {"$($_.firstName)"}}, 
@{N ="Surname";E = {"$($_.lastName)"}},
@{N ="SamAccountName"; E = {$($_.email) -replace ".{13}$"}},
@{N = "Path"; E = {format-OU -ou $_.orgUnit}},
@{N = "EmailAddress"; E = {$($_.email)}} | 
select-object -Property Name,GivenName,Surname,SamAccountName,Path,Email | 
Export-Csv ".\NewADUsers.csv" -NoTypeInformation
