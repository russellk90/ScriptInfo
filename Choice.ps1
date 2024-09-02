# Reads Connection Info
#Connect-VIServer osihvc04

[string]$configname="config2.ini"

# Reads in the config from the configuration file
$CurrentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
[String]$ConfigDir = $CurrentDir + "\" + $ConfigName
$ConfigData = (Get-Content $ConfigDir) -replace ("\\", "\\") -replace ("\[.*\]", "") -replace (";.*$", "") | ConvertFrom-StringData

function Show-existing-objects {
	param (
		[parameter(mandatory=$true)][string[]]$list,
		[parameter(mandatory=$true)][String]$object
)

$answer=-1
write-host "`r`nThis is a list of each" $object "available:"
	#Display each option with the number beside them 
	for ($i=0;$i -lt $list.length;$i++) {
	Write-host $($i+1) ":" $list[$i] -Foregroundcolor yellow
}

do {

$noerror=$true
$answer=read-host "choose by typing in the number beside your chosen" $object
if($answer -in 1..$List.length) {
$ChosenObject=$List[$answer-1]
}
else {$noerror=$false
Write-Host "Error: Choose a number within the range" -Foregroundcolor Red}
} until ($noerror)

Write-host $chosenobject "chosen as" $object "`n" -Foregroundcolor Green
return $chosenobject
}

$Choice=Show-existing-objects (invoke-expression -command $configData.ChoiceList) "script"

invoke-expression -command "C:\webaccess\$choice"