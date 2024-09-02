$id="osi.net\SERVERSUS2_gMSA"
$ShowAdmins=Net Localgroup Administrators
$ShowID=Get-LocalGroupMember -name "administrators" | where{$_.Name -like "*$id*"}
 
$comps = Get-Content '\\osihfile02\j$\IT\San\GMSA Accounts\TestServer.txt'

foreach ($comp in $Comps){
Write-Host "Testing connection to $($comp)" -ForegroundColor DarkGreen

Write-Host "Show All Local Admin accounts on $($comp)" -ForegroundColor Yellow
$ShowAdmins  | Format-Table -Property * -AutoSize 

Write-Host "Find SERVERSUS2_gMSA on $($comp)" -ForegroundColor Yellow
$ShowID  | Format-Table -Property * -AutoSize 



}

