
#get-service wuauserv | select Displayname,Status


$file = "C:\test\processes.csv"  
$computers =("osihserversus02","osihexchange02","osihimarcharch")  
Get-service -ComputerName $computers | Select-Object MachineName, Name, DisplayName, Status, StartType | ForEach-Object{  
    if($_.displayname -eq "windows update") {  
        Write-Host $_.MachineName,$_.Name, $_.DisplayName, $_.Status, $_.StartType -ForegroundColor Green          
    }  
    else{  
        Write-Host $_.MachineName,$_.Name, $_.DisplayName, $_.Status, $_.StartType -ForegroundColor Red  
    }  
    $_   
} | Export-Csv -NoTypeInformation -Path $file
