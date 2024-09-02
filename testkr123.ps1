
#get-service wuauserv | select Displayname,Status

#if ((Get-Service -Name wuauserv).Status -ne "Running"){
#Start-Service -Name wuauserv
$file = C:\work\kr\test\Wuauserv.csv  

$Start = Start-Service -Name wuauserv
#$computers =("osihserversus02","osihexchange02","osihimarcharch")  
$computers = Get-Content "C:\Work\kr\Test\testserverinfo.txt"

Get-service -name wuauserv -ComputerName $computers | Select-Object MachineName, Name, DisplayName, Status, StartType | ForEach-Object{  
    if($_.status -eq "running") {  
        Write-Host $_.MachineName,$_.Name, $_.DisplayName, $_.Status, $_.StartType -ForegroundColor Green          
    }  
    else{  
        Write-Host $_.MachineName,$_.Name, $_.DisplayName, $_.Status, $_.StartType -ForegroundColor Red
        $Start  
        
    }  
    $_   
} 
 Export-Csv -NoTypeInformation -Path $file
