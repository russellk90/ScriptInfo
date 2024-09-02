$servers = Get-Content "C:\test\TestListServersWeek1.txt"
#$servers = Get-Content "C:\test\TestListServersWeek2.txt"
#$servers = Get-Content "C:\test\TestListServersWeek3.txt"
#$servers = Get-Content "C:\test\TestListServersWeek4.txt"

$osver = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion") | Select-Object -Property ProductName,DisplayVersion


foreach ($server in $servers)

#Invoke-Command -ScriptBlock { 


{

Write-Host "Scanning the event log of: " -NoNewline; Write-Host $server;

Get-Eventlog -LogName system -newest 10 -instanceid 19,43,44 | Out-File "C:\test\ServerInfoWeek1.csv" -Append
#Get-Eventlog -LogName system -newest 10 -instanceid 19,43,44 | Out-File "C:\test\ServerInfoWeek2.csv" -Append
#Get-Eventlog -LogName system -newest 10 -instanceid 19,43,44 | Out-File "C:\test\ServerInfoWeek3.csv" -Append
#Get-Eventlog -LogName system -newest 10 -instanceid 19,43,44 | Out-File "C:\test\ServerInfoWeek4.csv" -Append


#}

#Write-Host "Current Os installed: "$osver"


#| ft  -wrap >> "C:\test\ServerInfo.csv"}

}

#Get-EventLog system -ComputerName $server -After (Get-Date).AddHours(-12) | where {($_.EntryType -Match "Error") -or ($_.EntryType -Match "Warning")} | ft  -wrap >> "C:/$server.csv";
