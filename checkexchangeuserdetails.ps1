
## Get list of device to check
#$comps = Get-Content '\\osihfile02\j$\IT\San\GMSA Accounts\Computers.txt' Testing
#$comps = Get-Content "\\osihfile02\it\San\GMSA Accounts\TestPatchSystemUser.txt"
$exchusers = Get-Content "c:\test\ExchUserList.txt"


#$GmsaUser = "*System*"
#$status = "Ready"    
#$Task = "*patch*"	
	
## Loop through each device
foreach ($exchuser in $exchusers){



Write-Host "Current user connected to $($exchuser)" -ForegroundColor Blue

$resa = Get-Mailbox -Identity "$exchuser" | Get-MailboxPermission | ft -AutoSize
Write-Host "hello test for permissons part 1"
$resa -ForegroundColor Green


$res01 = Get-Mailbox -Identity "$exchuser" | Get-ADPermission | ? { $_.extendedrights -like "*send*"} | ft -AutoSize user,extendedrights
Write-Host "hello test for permissons part 2 "
$res01 -ForegroundColor Yellow

#$TC = Test-Connection $exchuser -Count 1 -ErrorAction SilentlyContinue


#if ($TC){
#	echo "you are past connection" 
#Write-Host "Checking $($exchuser)" -ForegroundColor Green


#echo " the current user being searched is $exchuser"
#$resa = Get-Mailbox -Identity "$exchuser" | Get-MailboxPermission | ft -AutoSize


#$res01 = Get-Mailbox -Identity "$exchuser" | Get-ADPermission | ? { $_.extendedrights -like "*send*"} | ft -AutoSize user,extendedrights
#Write-Host "send as permissons are below for $exchuser"


## Check scheduled task for specified run as account
#$schtask = schtasks.exe /query /V /S $comp /FO CSV | ConvertFrom-Csv | Select-Object HostName,TaskName,Status,"Next Run Time","Run As User" |
#Where-Object {$_."Run As User" -like $GmsaUser} |
#Where-Object {$_."Status" -like $status} |
#Where-Object {$_."TaskName" -like $Task} 


#if ($schtask){

## Export results
#Write-Host "Task found "
#$schtask | select "Run As User",TaskName,HostName | Format-Table -Property * -AutoSize 

#}
#else {
#Write-Host "No task found with run as account"
#}

#}
#else {
#Write-Host "$($exchuser) not found" -ForegroundColor Yellow

#}


#}
}