

$comps = Get-Content '\\osihfile02\j$\IT\San\GMSA Accounts\TestServer.txt'

Invoke-Command -ComputerName $comps -ScriptBlock{
   Net Localgroup Administrators "osi.net\SERVERSUS2_gMSA$" /add
}	

