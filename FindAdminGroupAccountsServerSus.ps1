$id="osi.net\SERVERSUS2_gMSA$"
$ShowUsers=Net Localgroup administrators
$ShowID=Get-LocalGroupMember -Group "administrators" -Member 'osi.net\SERVERSUS2_gMSA$' #| where{$_.Name -like "*$id*"}
#Remove-LocalGroupMember -Group 'administrators' –Member 'osi.net\SERVERSUS2_gMSA$'
 
$comps = Get-Content 'C:\test\logs\Serverlist2.txt'


foreach ($comp in $Comps){
Write-Host "Testing connection to $($comp)" -ForegroundColor magenta

Write-Host "Show All Local Admin accounts on $($comp)" -ForegroundColor cyan
$ShowUsers  | Format-Table -Property * -AutoSize 

Write-Host "TEST"

Write-Host "Find SERVERSUS2_gMSA on $($comp)" -ForegroundColor Yellow
$ShowID  | Format-Table -Property * -AutoSize 



}

