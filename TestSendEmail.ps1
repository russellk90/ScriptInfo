
#$FileGet="C:\Users\russellk\Documents\Hello.txt"

$comp = $env:COMPUTERNAME
$date = Get-date

$SMTPServer = "barracuda.osi.ie" 
#$SMTPServer = "smtp.osi.net"
#$SMTPServer = "192.168.1.12" 

$EmailTo = "patching@tailte.ie"
$EmailFrom = "windowsUpdatepowershell@tailte.ie"

$Subject =  "$comp Server Information $date" 
$Body = " test email functionality working from new smtp sever connection $SMTPServer "


$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
#$attachment = New-Object System.Net.Mail.Attachment("$FileGet")

#$SMTPMessage.Attachments.Add("$FileGet")

$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer)
$SMTPClient.Send($SMTPMessage)


