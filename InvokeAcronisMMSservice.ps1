$status = Get-Service -Name "mms"

$RemoteComputers = Get-Content C:\patching\AcronisServersList.txt

Write-Host "List of server to check "
$RemoteComputers

ForEach ($Computer in $RemoteComputers)
{
     #Try
     #    {
			 Write-Host "connected on this machine: $Computer " -foregroundcolor cyan
			 Write-Host "checking status  " -foregroundcolor yellow

   Invoke-Command -ComputerName $Computer -ScriptBlock {Powershell.exe "get-Service -name "mms""} -ErrorAction Stop
   

}

