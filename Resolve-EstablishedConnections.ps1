Function Resolve-EstablishedConnections {

$EstConnections = Get-NetTCPConnection -State Established
$ConnectionArr = New-Object System.Collections.ArrayList
$Counter = 1
ForEach ($Connection in $EstConnections) {
    Write-Progress -Activity "Resolving PTR Record" -Status "Looking up $($Connection.RemoteAddress)" -PercentComplete ($Counter / $($EstConnections.Length)*100)

    $ConnectionObj = [PSCustomObject][Ordered] @{
    LocalAddress = $Connection.LocalAddress
    LocalPort = $Connection.LocalPort
    RemoteAddress = $Connection.RemoteAddress
    RemoteName = Resolve-DnsName -Name $Connection.RemoteAddress -ErrorAction SilentlyContinue | Select-Object -ExpandProperty NameHost
    RemotePort = $Connection.RemotePort
    State = $Connection.State
}

$ConnectionArr.Add($ConnectionObj) | Out-Null
$Counter++
} #End ForEach

$ConnectionArr | Out-GridView -Title Resolve-EstablishedConnections
Return $ConnectionArr
} #End Resolve-EstablishedConnections

. Resolve-EstablishedConnections