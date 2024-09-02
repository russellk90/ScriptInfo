
## Get list of device to check
#$comps = Get-Content '\\osihfile02\j$\IT\San\GMSA Accounts\Computers.txt' Testing
#$complist = Get-Content "C:\Patching\DeviceInfo.txt"
$complist = Get-Content "c:\test\testkev\test\ServerInfo.txt"


#$comps = Get-Content "c:\Test\server2016.txt"
#$comps = Get-Content "c:\Test\server2019.txt"
#$comps = Get-Content "c:\Test\server2022.txt"

#$complist = Get-Content "D:\PowerShell\complist.txt"

#$Servers = Get-ADComputer -Filter {(OperatingSystem -like "*windows*server*") -and (Enabled -eq "True")} -Properties OperatingSystem, name | Sort Name
$Servers = Get-ADComputer -Filter {(OperatingSystem -like "*server*") -and (Enabled -eq "True")} -Properties OperatingSystem, name | Sort Name

$hostname = ([System.Net.Dns]::GetHostByAddress($_)).Hostname


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
$servers |select name, operatingsystem, IPV4Address | sort OperatingSystem | Format-Table -AutoSize 