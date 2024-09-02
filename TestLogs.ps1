$comps = Get-Content "C:\work\kr\test\LogsForPatching\testServerList.txt"
#$Servers2 = Get-Content "C:\work\kr\test\LogsForPatching\Week2ServerList.txt"
#$Servers2 = "F6WINMSSTEST","F6WINMSSTEST2","F6WINMSSTEST3","F6WINMSSTEST4","F6WINMSSTEST5" 
#$Servers3 = "F6WINMSSTEST","F6WINMSSTEST2","F6WINMSSTEST3","F6WINMSSTEST4","F6WINMSSTEST5" 
#$Servers4 = "F6WINMSSTEST","F6WINMSSTEST2","F6WINMSSTEST3","F6WINMSSTEST4","F6WINMSSTEST5" 


## Loop through each device
foreach ($comp in $Comps){
Write-Host "Testing connection to $($comp)" -ForegroundColor DarkGreen
$TC = Test-Connection $comp -Count 1 -ErrorAction SilentlyContinue

if ($TC){
Write-Host "Checking $($comp)" -ForegroundColor Green

## Check scheduled task for specified run as account

$Results = Get-EventLog -ComputerName $comp -logname System -After (Get-Date).AddDays(-7) | where-object { $_.instanceid -eq 19}
    
 # Get-EventLog -ComputerName $server -logname System -After (Get-Date).AddDays(-10) | where-object { $_.instanceid -eq 19 -or $_.instanceid -eq 43 -or  $_.instanceid -eq 44}
 # Get-EventLog -ComputerName $server -logname System -After (Get-Date).AddDays(-30) | where-object { $_.instanceid -eq 19 -or $_.instanceid -eq 44}

if ($Results){

## Export results
Write-Host "Info Found "
#Get-EventLog -ComputerName $comp -logname System -After (Get-Date).AddDays(-7) | where-object { $_.instanceid -eq 19}     
$Results
}

else {

Write-Host  $comp  "No Info found this time"


}
  

echo $comp info outputed above 
             
    #Get-EventLog -logname system -Newest 3 | where-object { $_.instanceid -eq 19 -or $_.instanceid -eq 43 -or  $_.instanceid -eq 44} 
    #Get-EventLog -computer $server -LogName System -InstanceId 19,43,44 -Newest 2 

# echo $Server 
}

 Out-File C:\Work\kr\Test\LogsForPatching\TestLoginfo.txt


}