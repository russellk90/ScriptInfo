Connect-VIServer osihvc04 

write "connect to vcentre"
$vcenter_srv = "osihvc04"

Write "Gather Server List"

Get-VM | select -Expandproperty Name  | out-file c:\WebAccess\VMWARE\ServersList.txt

#cat C:\WebAccess\VMWARE\ServersList.txt








