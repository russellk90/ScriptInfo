$ServerStatus=Get-service -Name wuauserv | select displayname , status 
$comps = Get-Content "C:\Work\kr\Test\testserverinfo.txt"

foreach ($comp in $Comps){

if ((Get-Service -Name wuauserv).Status -ne "Running"){
            Start-Service -Name wuauserv}

}

foreach ($comp in $Comps){
#Write-Host "Testing connection to $($comp)" 

Write-Host "$($comp)" -ForegroundColor Yellow
$ServerStatus  
#|Export-CSV -Path "C:\work\kr\test\wuauserv.csv" -NoTypeInformation

}

 