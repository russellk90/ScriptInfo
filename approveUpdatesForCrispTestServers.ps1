
$To = "andrew.moore@osi.ie","eugene.kearns@osi.ie","dawn.williams@osi.ie","john.Kennedy@osi.ie"
$From = "windowsUpdatepowershell@osi.ie"
$EmailReport = $true
$SMTPServer = "smtp.osi.net"
$ServerNames = "OSIHCRISPGTST01","OSIHCRISPITST01","OSIHCRISPWTST01","OSIHCRISPWADM01"

echo $ServerNames

$date = Get-date
$date = $date.AddDays(12)
$date = $date.ToString("dd/MM/yyyy")
echo $date

echo "The following Patches will be applied to the following servers next early Tuesday morning " | Out-File C:\output.txt 
echo "" | Out-File -append C:\output.txt 

try
{

#echo "`n" | Out-File C:\output.txt
foreach( $Server in $ServerNames)
{

     $WuList =Get-WUList -Computername $Server
     
    echo $Wulist.Count
    if( $WuList.Count -Eq 0 )
    {
        
        echo $Server "The above server has no patches to be applied this month and is up to date with its patches" | Out-File -append C:\output.txt
       

        echo "The above server has the following space on the C: drive. More than 5GB should be available to prevent problems patching." | Out-File -append C:\output.txt
        $disk=Get-WmiObject Win32_LogicalDisk -ComputerName $Server -Filter "DeviceID='C:'"| Select-Object Size,FreeSpace
      
        echo "Disk Size" ($disk.Size /1GB) | Out-File -append C:\output.txt 
        echo "Free Size" ($disk.freeSpace /1GB) | Out-File -append C:\output.txt 
        echo "" | Out-File -append C:\output.txt 
    } 
    else
    {
        echo $Server " The above server has the following patches approved for installation." | Out-File -append C:\output.txt 
        echo "If you or your supporting vendor think there will be issue with any of the above please let us know by logging a call on the ITHelpdesk" | Out-File -Append C:\output.txt
        echo $WuList | Out-File -append C:\output.txt 
        
        echo "The above server has the following space on the C: drive. More than 5GB should be available to prevent problems patching." | Out-File -append C:\output.txt
        $disk=Get-WmiObject Win32_LogicalDisk -ComputerName $Server -Filter "DeviceID='C:'"| Select-Object Size,FreeSpace
        
        echo "Disk Size" ($disk.Size /1GB) | Out-File -append C:\output.txt 
        echo "Free Size" ($disk.freeSpace /1GB) | Out-File -append C:\output.txt
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
                Subject = "Scheduled patching for Web Services Test Servers for 4th Tuesday of the Month"                        
                Body =  $Report             
                from = $From                        
                To = $To                      
                SmtpServer = $SMTPServer                         
            }                        
            Send-MailMessage @messageParameters
			}

