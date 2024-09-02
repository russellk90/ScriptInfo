#$computers = Get-Content "C:\Logs\AD_Servers.txt" # Add servers in .txt file
#$ScomComputers = Get-Content "C:\Patching\UserList.txt" # Add servers in .txt file
#$ScomComputers = Get-Content "C:\Patching\AcronisServersList.txt" # Add servers in .txt file
#$ScomComputers = Get-Content "C:\test\serverlist.txt" # Add servers in .txt file
$ScomComputers = Get-Content "C:\test\TestListServers.txt" # Add servers in .txt file

$path1="C:\Patching\NewAuditStatsInfo.ps1"
$path2="C:\Patching\auditinfostats.ps1"


# This is the file/folder(s) you want to copy to the servers in the $computer variable
#$source = "\\osihserversus02\c$\Patching\ScomTesting\ScomMaintMode.xml"
#$source2 = "c:\Patching\PendingUpdateInfo.ps1"
#$source2 = "c:\Patching\AD_CheckServices.ps1"
#$source1a = "\\osihserversus02\c$\Patching\CheckAllSoftware.ps1"
#$source1b = "\\osihserversus02\c$\Patching\PendingUpdateInfo.ps1"
#$source1d = "\\osihserversus02\c$\Patching\StartServiceAcronisMMS.ps1"
#$source1d = "\\osihserversus02\c`$\test\testkev\TestPageFileSettings.ps1"
#$source1d = "\\osihserversus02\c$\Patching\MultiSearchQuery.ps1"
#$source1c = "\\osihserversus02\c$\Patching\windowsUpdateAndLogging.ps1"
#$source1d = "\\osihserversus02\c$\Patching\ActivationStats.ps1"
#$source1e = "\\osihserversus02\c$\Patching\NewAuditStatsInfo.ps1"


# The destination location you want the file/folder(s) to be copied to
$destination = "C$\Patching\"

$Results = foreach ($ScomComputer in $ScomComputers) {
#    Copy-Item $source -Destination \\$computer\$destination -Force -PassThru -Verbose
#    Copy-Item $source1 -Destination \\$computer\$destination -force -PassThru -Verbose
#    Copy-Item $source1a -Destination \\$ScomComputer\$destination -recurse -force -PassThru -Verbose
#    Copy-Item $source1b -Destination \\$ScomComputer\$destination -recurse -force -PassThru -Verbose
#    Copy-Item $source1c -Destination \\$ScomComputer\$destination -recurse -force -PassThru -Verbose
#    Copy-Item $source1c -Destination \\$ScomComputer\$destination -recurse -force -PassThru -Verbose
#	Copy-Item $source1d -Destination \\$ScomComputer\$destination -recurse -force -PassThru -Verbose
	#Copy-Item $source1e -Destination \\$ScomComputer\$destination -recurse -force -PassThru -Verbose
	
Invoke-Command -ComputerName $ScomComputer -FilePath $path1

Invoke-Command -ComputerName $ScomComputer -FilePath $path2

} 


# J:\San\KR\CopyFile.ps1

