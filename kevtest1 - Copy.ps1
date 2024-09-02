$file = "c:\patching\auditinfostats.txt"
$freshlog = Clear-Content -Path "c:\patching\auditinfostats.txt"


$To = "kevin.russell@tailte.ie"
$From = "windowsUpdatepowershell@tailte.ie"
$EmailReport = $true
$SMTPServer = "smtp.osi.net"
$ServerNames = "osihserversus02", "osihfile03"
#$ServerNames = "osihextdb01", "osihextdb01", "osihdmzsus01", ""



echo $ServerNames

$date = Get-date
$date = $date.AddDays(12) 
$date = $date.ToString("dd/MM/yyyy")
echo $date

foreach( $Server in $ServerNames)
{

$file = "c:\patching\auditinfostats.txt"
$freshlog = Clear-Content -Path "c:\patching\auditinfostats.txt"


Write-Host "" 
Write-Host "" 

Write-Host "$Server" -foregroundcolor cyan

echo "" | Out-File -append $file
echo "" | Out-File -append $file

Write-Host ""
Write-Host "Cleaning txt file for fresh logs" -foregroundcolor Yellow
$freshlog
echo "Cleared old logs" | Out-File -append $file

echo "" | Out-File -append $file
echo "" | Out-File -append $file


Write-Host ""
Write-Host "Server Name Below - saving in logs " -foregroundcolor Yellow
echo  "Stats 1 - server name  " | Out-File -append $file
hostname | Out-File -append $file


echo "" | Out-File -append $file
echo "" | Out-File -append $file


Write-Host "" 
Write-Host "last 5 patches info saving in logs" -foregroundcolor Yellow
echo "Stats 2 - patching info" | Out-File -append $file
Get-Eventlog -LogName system -newest 5 -instanceid 19,43,44 | ft -AutoSize -Wrap | Out-File -append $file


echo "" | Out-File -append $file
echo "" | Out-File -append $file


Write-Host ""
Write-Host "Local Admin info saving in logs" -foregroundcolor Yellow
echo "Stats 3 - local admin info " | Out-File -append $file
net localgroup "administrators" | Out-File -append $file


echo "" | Out-File -append $file
echo "" | Out-File -append $file


Write-Host ""
Write-Host "RDP User Info saving in logs " -foregroundcolor Yellow
echo "Stats 4 - RDP User Info" | Out-File -append $file
net localgroup "remote desktop users" | Out-File -append $file


echo "" | Out-File -append $file
echo "" | Out-File -append $file


Write-Host ""
Write-Host "RDS Licensing Info saving in logs " -foregroundcolor Yellow
echo "Stats 5 - RDS Licensing Info" | Out-File -append $file
Get-WindowsFeature -Name RDS-Licensing | Select-Object -Property DisplayName,Installed | Out-File -append $file


echo "" | Out-File -append $file
echo "" | Out-File -append $file


Write-Host ""
Write-host "This is the task sched info  saving in logs  " -foregroundcolor Yellow
echo "Stats 6 - task sched info" | Out-File -append $file
schtasks.exe /query /V /FO CSV | ConvertFrom-Csv | Where { $_.TaskName -ne "TaskName"  -and $_.location -like "**"}|Select-Object @{ label='Name';     expression={split-path $_.taskname -Leaf} }, Author ,'run as user','task to run'| select name, 'run as user' | Format-Table -Property * -AutoSize| Out-String -Width 4096 | Out-File -append $file

echo "" | Out-File -append $file
echo "" | Out-File -append $file




Write-Host ""
Write-Host "File with save logs found following location $file " -foregroundcolor Yellow

echo "" | Out-File -append $file
echo "" | Out-File -append $file



}

 

$Report = [IO.File]::ReadAllText("$file")
#Report to e-mail if enabled
if ($EmailReport -eq $true) {
 $messageParameters = @{                        
                Subject = " KevAuditTest123 - $((Get-Date).ToShortDateString())"                        
                Body =  $Report             
                from = $From                        
                To = $To                      
                SmtpServer = $SMTPServer                         
            }                        
            Send-MailMessage @messageParameters
			}