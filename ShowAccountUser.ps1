
$comps = Get-Content '\\osihfile02\j$\IT\San\GMSA Accounts\TestServer.txt'
Invoke-Command -ComputerName $comps -ScriptBlock{

Get-LocalGroupmember -Name 'administrators' | where{$_.Name -like "*osi.net\serversus2*"}

}

