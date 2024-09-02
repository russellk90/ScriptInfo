#$Key = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Dependencies\VC,redist.x86,x86,14.34,bundle'
#$Key.Version

$pcname = "$Env:COMPUTERNAME"

write-host ""
write-host ""
echo "Software installed info"

$list=@()
$InstalledSoftwareKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
$InstalledSoftware=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$pcname)
$RegistryKey=$InstalledSoftware.OpenSubKey($InstalledSoftwareKey) 
$SubKeys=$RegistryKey.GetSubKeyNames()
Foreach ($key in $SubKeys){
$thisKey=$InstalledSoftwareKey+"\\"+$key
$thisSubKey=$InstalledSoftware.OpenSubKey($thisKey)
$obj = New-Object PSObject
$obj | Add-Member -MemberType NoteProperty -Name "$pcname" -Value $pcname
$obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))
$obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))
$list += $obj
}

write-host ""
Write-Host "Currently checking all software installed for $pcname" -ForegroundColor Green
$list | where { $_.DisplayName } | select DisplayName, DisplayVersion 


Start-Sleep -Seconds 5
write-host ""
write-host ""
echo "Update Event logs info"


$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
write-host ""
Write-Host "Show pending updates below if any available"  -foregroundcolor Green
$Updates | Select-Object Title 



Start-Sleep -Seconds 5
write-host ""
write-host ""
echo "Page file info"


$colItems = get-wmiobject -class "Win32_PageFileUsage" -namespace "root\CIMV2" -computername localhost 
 
foreach ($objItem in $colItems) { 
      $allocate = $objItem.AllocatedBaseSize
      $current = $objItem.CurrentUsage
} 

write-host ""
write-host "Virtual memory (Page File usage for all drives) info in mb below" -ForegroundColor Green
write-host ($allocate - $current)


Start-Sleep -Seconds 5
write-host ""
write-host ""
echo "disk volume info"

write-host ""
write-host "The disk volume info can be seen below" -ForegroundColor Green
Get-Volume | ft -AutoSize


Start-Sleep -Seconds 5
write-host ""
write-host ""
echo "patching info"

Write-Host "last 5 patches info" -foregroundcolor Green
Get-Eventlog -LogName system -newest 5 -instanceid 19,43,44 | ft -AutoSize -Wrap


Start-Sleep -Seconds 5
write-host ""
write-host ""

echo "Server Uptime info"

write-host ""
write-host "Get server uptime details" -ForegroundColor Green
Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object LastBootUpTime
