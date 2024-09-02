
$comps = Get-Content "\\osihfile02\it\San\GMSA Accounts\TestPatchSystemUser.txt"

Invoke-Command -ComputerName $comps -ScriptBlock{

write-host "Server connected on $env:COMPUTERNAME" -ForegroundColor Green

#variables
$id = "NT Authority\System"
$taskname = "Patch_and_Reboot"

$princ = New-ScheduledTaskPrincipal -UserID "$id" -LogonType Password -runlevel highest
$Getinfo = Get-ScheduledTask -TaskName "$taskname"

Write-Host "Configure User Settings for $taskname on $($comp)" -ForegroundColor Yellow
$princ  

Write-Host "Set the UserID on task $taskname on  $($comp)" -ForegroundColor Yellow
Set-ScheduledTask -TaskName "$taskname" -Principal $princ


}

#Write-Host "Query Task Schedule on $($comp)" -ForegroundColor Yellow
#schtasks.exe /query /V /FO CSV | ConvertFrom-Csv | Where { $_.TaskName -ne "TaskName"  -and $_.TaskName -like "*Patch*"}|Select-Object @{ label='Name';     expression={split-path $_.taskname -Leaf} }, Author ,'run as user','task to run'| Format-Table -Property * -AutoSize| Out-String -Width 4096




#\\osihnasvdi01\RedirectedFolders\russellk$\Downloads\SystemAccountSet.ps1

