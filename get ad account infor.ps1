
Get-WsusComputer -NameIncludes sligodc04


Get-ADServiceAccount  -Filter * -Properties CanonicalName, sAMAccountType, SamAccountName, Description 


Get-WsusComputer "sligodc04"


#Service accounts below 

 Get-ADServiceAccount -Filter * -Properties * | `
    Select -Property Name, `
        @{name="Owner"; expression={(Get-Acl "AD:\$($_.DistinguishedName)").Owner}}, `
        Enabled, LockedOut, Description,
        @{name="LastLogonDate"; expression={ $_.LastLogonDate.toString("dd.MM.yyyy") }}, `
        @{name="PasswordLastSet"; expression={ $_.PasswordLastSet.toString("dd.MM.yyyy") }}, `
        DistinguishedName | `
        Out-GridView




         Get-ADServiceAccount -Filter * -Properties * | `
    Select -Property Name, `
        @{name="Owner"; expression={(Get-Acl "AD:\$($_.DistinguishedName)").Owner}}, `
        Enabled, Description, DistinguishedName | Out-GridView 


ST_ADServiceAcc	OSI.NET\Domain Admins	True		CN=ST_ADServiceAcc,CN=Managed Service Accounts,DC=osi,DC=net	
mrdspart_gMSA	OSI.NET\Domain Admins	True	Group Managed service account for osihmrdspart01 and osihmrdspart02	CN=mrdspart_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
mrdspdev_gMSA	OSI.NET\Domain Admins	True	osihmrdspdev01 and osihmrdspdev01 call 78326	CN=mrdspdev_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
osihfme03_gMSA	OSI.NET\Domain Admins	True	osihfme03 and osihfile02	CN=osihfme03_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
osihfme04_gMSA	OSI.NET\Domain Admins	True	osihfme04 and osihfile02	CN=osihfme04_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
webserv_gMSA	OSI.NET\Domain Admins	True	osiharcgis02 and osihipsatst	CN=webserv_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
SanServer_gMSA	OSI.NET\Domain Admins	True	san Server group managed service account	CN=SanServer_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
osihsql04_gMSA	OSI.NET\Domain Admins	True	Osihsql04 SQL DB Service Account	CN=osihsql04_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
NetSec_gMSA	OSI.NET\Domain Admins	True	osihradius01 and osihepo02	CN=NetSec_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
patchrboot_gMSA$	OSI.NET\Domain Admins	True	osihdc1,osihdc3,osihwsus01,kilkdc04	CN=patchrboot_gMSA$,CN=Managed Service Accounts,DC=osi,DC=net	
Testscom_gMSA	OSI.NET\Domain Admins	True	osihscom04	CN=Testscom_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
OpsMgrAdm_gMSA	OSI.NET\Domain Admins	True	Scom2019 Install Account	CN=OpsMgrAdm_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
OMDAS_gMSA	OSI.NET\Domain Admins	True	Scom2019 Data Access System Config Account	CN=OMDAS_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
OpsRead_gMSA	OSI.NET\Domain Admins	True	Scom 2019 Data Read Account	CN=OpsRead_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
OpsWrite_gMSA	OSI.NET\Domain Admins	True	Scom 2019 Data Write Account	CN=OpsWrite_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	
OpsAct_gMSA	OSI.NET\Domain Admins	True	Scom 2019 Action Account	CN=OpsAct_gMSA,CN=Managed Service Accounts,DC=osi,DC=net	


