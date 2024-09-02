

#$RemoteComputers = @("PC1","PC2")

$RemoteComputers = Get-Content C:\patching\UserList2.txt

ForEach ($Computer in $RemoteComputers)
{
     Try
         {
			 Write-Host "connected on this machine: $Computer " -foregroundcolor cyan
             Invoke-Command -ComputerName $Computer -ScriptBlock {Powershell.exe "C:\Patching\CheckAllSoftware.ps1"} -ErrorAction Stop
         }
     Catch
         {
#             Add-Content c:\patching\SoftwareLogs.txt $Computer
         }
}