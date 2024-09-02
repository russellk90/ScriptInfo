
Write-Host "Gathering Information about c++"

$res = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Classes\Installer\Dependencies\VC,redist.x86,*' -Name Version
$res

