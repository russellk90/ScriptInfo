
Write-Host "get pending updates below"  -foregroundcolor yellow
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
$Updates | Select-Object Title


Write-Host "last 5 patches info" -foregroundcolor cyan

Get-Eventlog -LogName system -newest 5 -instanceid 19,43,44 | ft -AutoSize -Wrap


