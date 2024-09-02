
## Get list of device to check
#$comps = Get-Content '\\osihfile02\j$\IT\San\GMSA Accounts\Computers.txt' Testing
$complist = Get-Content "C:\Work\kr\Test\allserverslist2.txt"
#$comps = Get-Content "c:\Test\server2016.txt"
#$comps = Get-Content "c:\Test\server2019.txt"
#$comps = Get-Content "c:\Test\server2022.txt"

#$complist = Get-Content "D:\PowerShell\complist.txt"

#$Servers = Get-ADComputer -Filter {(OperatingSystem -like "*windows*server*") -and (Enabled -eq "True")} -Properties OperatingSystem, name | Sort Name
$Servers = Get-ADComputer -Filter {(OperatingSystem -like "*server*") -and (Enabled -eq "True")} -Properties OperatingSystem, name | Sort Name


foreach($comp in $complist){
    
    $pingtest = Test-Connection -ComputerName $comp -Quiet -Count 1 -ErrorAction SilentlyContinue

    if($pingtest){

         Write-Host($comp + " is online")
     }
     else{
        Write-Host($comp + " is not reachable") -ForegroundColor Yellow 
     }

     
}

#$pingtest | Out-File C:\Work\kr\Test\pinginfo.txt
$servers |select name, operatingsystem | Format-Table -AutoSize | Out-File C:\Work\kr\Test\nameosinfo.txt