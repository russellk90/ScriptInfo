#$Server01 = "osihsan"

#Invoke-Command -ComputerName $Server01 -filepath c:\patching\CheckAllSoftware.ps1

$comps = Get-Content 'C:\patching\UserList2.txt'

#$RunCmd = "Invoke-Command -filepath c:\patching\CheckAllSoftware.ps1"

$RunCmd = Powershell.exe -File c:\patching\CheckAllSoftware.ps1

$ScriptInfo = {

#Invoke-Command -scriptblock{
	
foreach($computer in $comps)  {

write-host "Server connected to $computer" -foregroundcolor Yellow
write-host "Gathering Logs " -foregroundcolor magenta

write-host " " 

$RunCmd	

write-host "Next server checking stats " -foregroundcolor cyan
write-host " " 

}

#}

}	

Invoke-Command -scriptblock $ScriptInfo

