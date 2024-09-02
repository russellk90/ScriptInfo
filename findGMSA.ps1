
$comps = Get-Content 'C:\test\logs\ServerList.txt'

Invoke-Command -ComputerName $comps -ScriptBlock{

#Remove-LocalGroupMember -Group 'administrators' –Member 'osi.net\SERVERSUS2_gMSA$'
#Add-LocalGroupMember -Group 'users' –Member 'osi.net\SERVERSUS2_gMSA$'
net localgroup "administrators" | where{$_.name -like "*serversus*"}

}	
