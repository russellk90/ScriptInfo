
$To = "andrew.moore@osi.ie","eugene.kearns@osi.ie","dawn.williams@osi.ie","John.Kennedy@osi.ie"
$From = "windowsUpdatepowershell@osi.ie"
$EmailReport = $true
$SMTPServer = "smtp.osi.net"
$ServerNames = "OSIHCRISPGTST01","OSIHCRISPITST01","OSIHCRISPWTST01","OSIHCRISPWADM01"

#Get-WUHistory | Where {$_.Date -gt [dateTime]::Today.AddDays(-1)}


echo "The following Patches where applied last night to the following Servers " | Out-File C:\output.txt

try
{

#echo "`n" | Out-File C:\output.txt
foreach( $Server in $ServerNames)
{

     $WuHistory =Get-WUHistory -Computername $Server | Where {$_.Date -gt [dateTime]::Today.AddDays(-1)}
     
    echo $WuHistory.Count
    if( $WuHistory.Count -Eq 0 )
    {
        
        echo $Server "The above server had no patches applied last night. There was either no patches applicable or there was an issue applying them" | Out-File -append C:\output.txt
        echo "" | Out-File -append C:\output.txt 
    } 
    else
    {
        echo $Server " The above server had the following patches installed last night." | Out-File -append C:\output.txt 
        echo "Please check and see if there are any issue with your applications" | Out-File -Append C:\output.txt
        echo $WuHistory | Out-File -append C:\output.txt 
        echo "" | Out-File -append C:\output.txt 
    }
    
}
}
Catch
{
    echo "Error in script" | Out-File C:\output.txt
    echo ($Error[0].exception) | Out-File C:\output.txt }

$Report = [IO.File]::ReadAllText("C:\output.txt")
#Report to e-mail if enabled
if ($EmailReport -eq $true) {
 $messageParameters = @{                        
                Subject = "Server Patching report for Web Services Test Servers $((Get-Date).ToShortDateString())"                        
                Body =  $Report             
                from = $From                        
                To = $To                      
                SmtpServer = $SMTPServer                         
            }                        
            Send-MailMessage @messageParameters
			}

