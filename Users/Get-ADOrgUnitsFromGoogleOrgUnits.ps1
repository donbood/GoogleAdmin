# Convert the OU paths from Google format to AD format

$users = .\Get-Users.ps1
$orgUnits = $users | select-object -ExpandProperty orgUnit -Unique
$outputArray = @()
$base = "" #your base DN

foreach ($ou in $orgUnits) {

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
    
    $outputArray += New-Object PsObject -Property @{
        'orgUnit' = $output
    }
}

$outputArray
