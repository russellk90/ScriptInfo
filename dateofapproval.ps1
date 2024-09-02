Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null

# This requires an elevated console/host.
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer()

# Create a computer scope that includes all computers that have at least one
# update reported to the WSUS server as in the installed state.
$ComputerScope = New-Object Microsoft.UpdateServices.Administration.ComputerTargetScope
$ComputerScope.IncludedInstallationStates = [Microsoft.UpdateServices.Administration.UpdateInstallationStates]::Installed

# Create an update scope that includes updates that are installed.
$UpdateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
$UpdateScope.IncludedInstallationStates = [Microsoft.UpdateServices.Administration.UpdateInstallationStates]::Installed

$Computers = $Wsus.GetComputerTargets($ComputerScope)

# Data hashtable, indexed by the computers' "FullDomainName" property.
$LastUpdateData = @{}

foreach ($Computer in $Computers) {
    
    #$ComputerName = $Computer.FullDomainName # -replace '\..+' # strip off domain, if present
    $LastUpdateData.($Computer.FullDomainName) = New-Object PSObject    
    
    $InstalledUpdates = $Computer.GetUpdateInstallationInfoPerUpdate($UpdateScope)
    
    # The updates apparently are sorted in the order they were installed,
    # so here I rely on this logic and store the arrival date and title
    # of the last installed update in the hashtable object.
    $InstalledUpdates | Select-Object -Last 1 | Foreach-Object {
        
        $Update = $_.GetUpdate()
        
        Add-Member -MemberType NoteProperty -Name 'ArrivalDate' -Value $Update.ArrivalDate -InputObject $LastUpdateData.($Computer.FullDomainName)
        Add-Member -MemberType NoteProperty -Name 'Title' -Value $Update.Title -InputObject $LastUpdateData.($Computer.FullDomainName)
        
    }
    
}

$LastUpdateData.GetEnumerator() | Sort-Object -Property @{Ascending=$true;e={$_.Value.ArrivalDate}},@{Ascending=$true;e={$_.Name}} |
    Select-Object -Property @{n='Host';e={$_.Name}},@{n='Arrival Date';e={$_.Value.ArrivalDate}},@{n='Title';e={$_.Value.Title}} | 
    ConvertTo-Csv -NoTypeInformation | Set-Content Last-WSUS-Updates.csv

@"

Total computers found with at least one update installed: $($LastUpdateData.Keys.Count)
Output file: Last-WSUS-Updates.csv
"@

notepad Last-WSUS-Updates.csv