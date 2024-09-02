$UserAccountinfo =  Get-ADUser -Properties "*" -Filter 'name -like "*"' | select name, samaccountname, lockedout | sort lockedout | ft -AutoSize
$ServiceAccountinfo = Get-ADServiceAccount -Properties "*" -Filter 'name -like "*"' | select name, samaccountname, lockedout | sort lockedout | ft -AutoSize

$Unlock="Unlock-ADAccount -Identity $LockedoutUsers"

Write-Host ""
Write-Host ""

Write-Host "All User accounts" -foregroundcolor Green
$UserAccountinfo 

Write-Host ""
Write-Host ""

Write-Host "All Service Accounts" -foregroundcolor Green
$ServiceAccountinfo 

Write-Host ""

Write-Host "to unlock any account do the following:   $unlock"

Write-Host ""
