$computers = Get-Content "C:\Logs\AD_Servers.txt" # Add servers in .txt file

# This is the file/folder(s) you want to copy to the servers in the $computer variable
#$source = "\\osihserversus02\c$\Patching\ScomTesting\ScomMaintMode.xml"
#$source1 = "\\osihimarcharch\c$\Patching\ScomMainteanceMode60Mins.ps1"
#$source2 = "c:\Patching\PendingUpdateInfo.ps1"
#$source2 = "c:\Patching\AD_CheckServices.ps1"

$source2 = "c:\Patching\ResumeBitlocker.ps1"
$source3 = "c:\Patching\SuspendBitlocker.ps1"


# The destination location you want the file/folder(s) to be copied to
$destination = "C$\Patching\"

$Results = foreach ($computer in $computers) {
#    Copy-Item $source -Destination \\$computer\$destination -Force -PassThru -Verbose
#    Copy-Item $source1 -Destination \\$computer\$destination -force -PassThru -Verbose
    Copy-Item $source2 -Destination \\$computer\$destination -force -PassThru -Verbose
    Copy-Item $source3 -Destination \\$computer\$destination -force -PassThru -Verbose
	
} 


# J:\San\KR\CopyFile.ps1

