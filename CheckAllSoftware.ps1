#$Key = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Dependencies\VC,redist.x86,x86,14.34,bundle'
#$Key.Version

$pcname = "$Env:COMPUTERNAME"

Write-Host "Currently checking all software installed for $pcname" -ForegroundColor Green


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


$list | where { $_.DisplayName } | select DisplayName, DisplayVersion | FT


Write-Host ""

Write-Host "Gathering Information about c++ for $pcname" -ForegroundColor Green

$res = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Installer\Dependencies\VC,redist.x86,*' -Name Version
$res


