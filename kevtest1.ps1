
$To = "kevin.russell@tailte.ie"
$From = "windowsUpdatepowershell@tailte.ie"
$EmailReport = $true
$SMTPServer = "smtp.osi.net"
$ServerNames = "OSIHGPS07","OSIHCRISPGPRD01","OSIHCRISPIPRD01","OSIHCRISPIPRD02","OSIHCRISPWPRD01","OSIHCRISPWPRD02","OSIHCRISPWADM02","osihipsaprd","osihipsaprdimg","osihext02", "osihext03","osihext05", "osihext06"," osihext07", "osihext08","osihext09", "osihext10","osihlic02","osihortvista01","osihhro01", "OSIHAPOLLO2020","osihapollo01", "osihapstore01", "osihfmeserver02", "osihpointc02" , "osihapstore02", "osihapstore03" , " osihwsmonoplot" , "osihwservmonadm", "osihwservmonsrv", "osihwservadmin" ,"osiharcconfig01", "osihp2sup", "osihpointdata2" , "osihfme03", "osihiisappprd01" , "osihiisapptst01", "osihgms03", "osihgms04", "osihmrdspart01", "osihmrdspart02"
# "osihmapgeniewm","osihmapgenieitm","osihmapgenieig"

echo $ServerNames

$date = Get-date
$date = $date.AddDays(12) 
$date = $date.ToString("dd/MM/yyyy")
echo $date
echo "This is kevtest server info event logs" | Out-File C:\kevtest1.txt
foreach( $Server in $ServerNames)
{

     #$WuList =Get-WUList -Computername $Server
$LogInfo =Get-Eventlog -LogName system -newest 10 -instanceid 19,44,43 -ComputerName $Server
     #echo $WuList | Out-File -append C:\output.txt 
echo $Server | Out-File -append C:\kevtest1.txt 
echo $LogInfo | Out-File -append C:\kevtest1.txt 
    #echo $Wulist.Count
    #if( $WuList.Count -Eq 0 )
    #{
        
    #    echo $Server "server has no patches to be applied this month and is up to date with its patches" | Out-File -append C:\output.txt
    #} 
    #else
    #{
     #   echo $Server " has the following patches approved for installation." | Out-File -append C:\output.txt 
     #   echo "If you or your supporting vendor think there will be issue with any of the above please let us know by logging a call on the ITHelpdesk" | Out-File -Append C:\output.txt

   # }
    
}
 

$Report = [IO.File]::ReadAllText("C:\kevtest1.txt")
#Report to e-mail if enabled
if ($EmailReport -eq $true) {
 $messageParameters = @{                        
                Subject = " Kevtest Log Event Info for wk 1 servers - $((Get-Date).ToShortDateString())"                        
                Body =  $Report             
                from = $From                        
                To = $To                      
                SmtpServer = $SMTPServer                         
            }                        
            Send-MailMessage @messageParameters
			}