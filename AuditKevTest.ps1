
$To = "kevin.russell@tailte.ie"
$From = "windowsUpdatepowershell@tailte.ie"
$EmailReport = $true
$SMTPServer = "smtp.osi.net"
#$ServerNames = "OSIHGPS07","OSIHCRISPGPRD01","OSIHCRISPIPRD01","OSIHCRISPIPRD02","OSIHCRISPWPRD01","OSIHCRISPWPRD02","OSIHCRISPWADM02","osihipsaprd","osihipsaprdimg","osihext02", "osihext03","osihext05", "osihext06"," osihext07", "osihext08","osihext09", "osihext10","osihlic02","osihortvista01","osihhro01", "OSIHAPOLLO2020","osihapollo01", "osihapstore01", "osihfmeserver02", "osihpointc02" , "osihapstore02", "osihapstore03" , " osihwsmonoplot" , "osihwservmonadm", "osihwservmonsrv", "osihwservadmin" ,"osiharcconfig01", "osihp2sup", "osihpointdata2" , "osihfme03", "osihiisappprd01" , "osihiisapptst01", "osihgms03", "osihgms04", "osihmrdspart01", "osihmrdspart02"
# "osihmapgeniewm","osihmapgenieitm","osihmapgenieig"

$ServerNames= "osihcd01", "osihcfgmgr01", "OSIHCG02", "osihserversus02"
$filepath = "C:\Patching\NewAuditStats.txt"


#$CMD1 = Invoke-Command -ComputerName $Server -FilePath c:\patching\AuditStatsInfo.ps1
#$saveoutput = Invoke-Command -ComputerName $Server -FilePath c:\patching\AuditStatsInfo.ps1 | Out-File  C:\patching\auditstatsinfo.txt


#$CMDA = Get-Content C:\kevtestcopystats.txt


$date = Get-date
$date = $date.AddDays(12) 
$date = $date.ToString("dd/MM/yyyy")

echo $date
echo " TESTING LOGS FOR THESE $ServerNames  " | Out-File  $filepath

Write-Host ""


foreach( $Server in $ServerNames)
{
#Write-Host "Audit Info Below $Server" -ForegroundColor Green 
#$CMD1
#$res1 = $saveoutput 
#$CMD1 | Out-File -Append  C:\kevtestcopystats.txt
#$res1
#Write-Host "Audit Stats info below - log location c:\kevtestcopystats " -ForegroundColor Green
#$CMDA

Write-Host ""
$Log1 = hostname
Write-Host "Server name is $log1" -foregroundcolor Green
Write-Host ""
$Output1 = $Log1 | Out-File -Append  $filepath


Write-Host ""
$Log2 = schtasks.exe /query /V /FO CSV | ConvertFrom-Csv | Where { $_.TaskName -ne "TaskName"  -and $_.location -like "**"}|Select-Object @{ label='Name';     expression={split-path $_.taskname -Leaf} }, Author ,'run as user','task to run'| select name, 'run as user' | Format-Table -Property * -AutoSize| Out-String -Width 4096
Write-host "This is the task sched info" -foregroundcolor Yellow
$log2 
Write-Host ""
$Output2 = $Log2 | Out-File -Append  $filepath

Write-Host ""
#$Log3 = Invoke-Command -FilePath C:\patching\PendingUpdateInfo.ps1
$log3 = Get-Eventlog -LogName system -newest 5 -instanceid 19,43,44 
Write-Host "Patching Stats Info" -foregroundcolor Yellow 
$Log3 | ft -AutoSize
Write-Host ""
$Output3 = $Log3 | Out-File -Append  $filepath


Write-Host ""
$Log4 = net localgroup administrators 
Write-Host "Local Admin Users" -foregroundcolor Yellow 
$Log4 | ft -AutoSize
Write-Host ""
$Output4 = $Log4 | Out-File -Append  $filepath


Write-Host ""
$Log5 = net localgroup "remote desktop users"
Write-Host "RDP User Info" -foregroundcolor Yellow
$Log5 | ft -AutoSize
Write-Host ""
$Output5 = $Log5 | Out-File -Append  $filepath





}



$Report = [IO.File]::ReadAllText("$filepath")
#Report to e-mail if enabled
if ($EmailReport -eq $true) {
 $messageParameters = @{                        
                Subject = " Audit Stats Info Testing - $((Get-Date).ToShortDateString())"                        
                Body =  $Report             
                from = $From                        
                To = $To                      
                SmtpServer = $SMTPServer                         
            }                        
            Send-MailMessage @messageParameters
			}



#$Server1= "osihcd01" 
#$CMD1 = Invoke-Command -ComputerName $Server1 -FilePath c:\patching\AuditStatsInfo.ps1
#$CMDA = Get-Content C:\kevtestcopystats.txt

#echo "$Server1"

#Write-Host "$Server1" -ForegroundColor DarkGreen 

#$res1 = $CMD1 | Out-File  C:\kevtestcopystats.txt

#Write-Host "Audit Stats info below " -ForegroundColor DarkGreen

#$CMDA
