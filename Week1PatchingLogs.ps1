$Servers1 = Get-Content "C:\work\kr\test\LogsForPatching\Week1ServerList.txt"
#$Servers2 = Get-Content "C:\work\kr\test\LogsForPatching\Week2ServerList.txt"
#$Servers2 = "F6WINMSSTEST","F6WINMSSTEST2","F6WINMSSTEST3","F6WINMSSTEST4","F6WINMSSTEST5" 
#$Servers3 = "F6WINMSSTEST","F6WINMSSTEST2","F6WINMSSTEST3","F6WINMSSTEST4","F6WINMSSTEST5" 
#$Servers4 = "F6WINMSSTEST","F6WINMSSTEST2","F6WINMSSTEST3","F6WINMSSTEST4","F6WINMSSTEST5" 


ForEach ($server in $Servers1) {
    Write-Host "connecting to $server" -ForegroundColor Yellow	
      
   # Get-EventLog -ComputerName $server -logname System -After (Get-Date).AddDays(-10) | where-object { $_.instanceid -eq 19 -or $_.instanceid -eq 43 -or  $_.instanceid -eq 44}
     
    # Get-EventLog -ComputerName $server -logname System -After (Get-Date).AddDays(-30) | where-object { $_.instanceid -eq 19 -or $_.instanceid -eq 44}
     
      Get-EventLog -ComputerName $server -logname System -After (Get-Date).AddDays(-10) | where-object { $_.instanceid -eq 19}
  
             
    #Get-EventLog -logname system -Newest 3 | where-object { $_.instanceid -eq 19 -or $_.instanceid -eq 43 -or  $_.instanceid -eq 44} 
    #Get-EventLog -computer $server -LogName System -InstanceId 19,43,44 -Newest 2 

Write-Host "$server info above" -foregroundcolor green

}




