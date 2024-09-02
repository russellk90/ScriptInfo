$Services='DNS','DFS Replication','Intersite Messaging','Kerberos Key Distribution Center','NetLogon',’Active Directory Domain Services’
ForEach ($Service in $Services) {Get-Service $Service | Select-Object Name, Status}
