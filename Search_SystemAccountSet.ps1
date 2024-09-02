
## Get list of device to check
#$comps = Get-Content '\\osihfile02\j$\IT\San\GMSA Accounts\Computers.txt' Testing
$comps = Get-Content "\\osihfile02\it\San\GMSA Accounts\TestPatchSystemUser.txt"
$GmsaUser = "*System*"
#$status = "Ready"    
$Task = "*patch*"	
	
## Loop through each device
foreach ($comp in $Comps){
Write-Host "Testing connection to $($comp)" -ForegroundColor DarkGreen
$TC = Test-Connection $comp -Count 1 -ErrorAction SilentlyContinue

if ($TC){
Write-Host "Checking $($comp)" -ForegroundColor Green

## Check scheduled task for specified run as account
$schtask = schtasks.exe /query /V /S $comp /FO CSV | ConvertFrom-Csv | Select-Object HostName,TaskName,Status,"Next Run Time","Run As User" |
Where-Object {$_."Run As User" -like $GmsaUser} |
#Where-Object {$_."Status" -like $status} |
Where-Object {$_."TaskName" -like $Task} 


if ($schtask){

## Export results
Write-Host "Task found "
$schtask | select "Run As User",TaskName,HostName | Format-Table -Property * -AutoSize 

}
else {
Write-Host "No task found with run as account"
}

}
else {
Write-Host "$($comp) not responding" -ForegroundColor Yellow

}


}
