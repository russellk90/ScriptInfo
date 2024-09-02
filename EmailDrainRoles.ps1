
#$FileGet="C:\Users\russellk\Documents\Hello.txt"

$comp = $env:COMPUTERNAME
$date = Get-date


$EmailTo = "SanServerTeam@tailte.ie"
$EmailFrom = "windowsUpdatepowershell@tailte.ie"
$Subject =  "Reminder: Drain Roles on the OSIHARCCONFIG Servers  $date" 
$Body = " Scheduled patching due as follows 
	osiharcconfig01 – set for updates on 1st Tuesday of month
	osiharcconfig02 – set for updates on 4th Tuesday of month 

Please ensure the disks/nodes and roles are set for osiharcconfig01 
This is required in order for the backup policy to run smoothly


 "
$SMTPServer = "smtp.osi.net"

$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)

$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer)
$SMTPClient.Send($SMTPMessage)

