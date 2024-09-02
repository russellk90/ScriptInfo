
$To = "andrew.moore@osi.ie"
$From = "windowsUpdatepowershell@osi.ie"
$EmailReport = $true
$SMTPServer = "smtp.osi.net"
$ServerNames = "OSIHCRISPGTST01","OSIHCRISPITST01","OSIHCRISPWTST01","OSIHCRISPWADM01","OSIHSAN","OSIHWSDBTEST"

echo $ServerNames

$date = Get-date
$date = $date.AddDays(12) 
$date = $date.ToString("dd/MM/yyyy")
echo $date
echo "The following Patches will be applied to the following servers" | Out-File C:\output.txt
foreach( $Server in $ServerNames)
{

     $WuList =Get-WUList -Computername $Server
     echo $WuList | Out-File -append C:\output.txt 
    echo $Wulist.Count
    if( $WuList.Count -Eq 0 )
    {
        
        echo $Server "server has no patches to be applied this month and is up to date with its patches" | Out-File -append C:\output.txt
    } 
    else
    {
        echo $Server " has the following patches approved for installation." | Out-File -append C:\output.txt 
        echo "If you or your supporting vendor think there will be issue with any of the above please let us know by logging a call on the ITHelpdesk" | Out-File -Append C:\output.txt

    }
    
}
 

$Report = [IO.File]::ReadAllText("C:\output.txt")
#Report to e-mail if enabled
if ($EmailReport -eq $true) {
 $messageParameters = @{                        
                Subject = "Windows Update report for $env:ComputerName.$env:USERDNSDOMAIN - $((Get-Date).ToShortDateString())"                        
                Body =  $Report             
                from = $From                        
                To = $To                      
                SmtpServer = $SMTPServer                         
            }                        
            Send-MailMessage @messageParameters
			}