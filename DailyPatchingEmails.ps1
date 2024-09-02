function isdayofmonth ([int]$Month, [int]$Year, $weekday, $firstsecondthirdorfourthdayofmonth) {

    $nameofmonth=(Get-Culture).DateTimeFormat.GetMonthName($month)
    [int]$Day = 1
    while((Get-Date -Day $Day -Hour 0 -Millisecond 0 -Minute 0 -Month $Month -Year $Year -Second 0).DayOfWeek -ne $weekday) {
        $day++
    }
    if ($firstsecondthirdorfourthdayofmonth -eq 2) {$day += 7}
    if ($firstsecondthirdorfourthdayofmonth -eq 3) {$day += 14}
    if ($firstsecondthirdorfourthdayofmonth -eq 4) {$day += 21}

    return (Get-Date -Day $Day -Hour 0 -Millisecond 0 -Minute 0 -Month $Month -Year $Year -Second 0 -format D)
}

$return= (isdayofmonth $datum.month $datum.year Wednesday 2)
echo $return
$datum=get-date
if ((isdayofmonth $datum.month $datum.year Tuesday 1) -eq (get-date -date $(get-date).adddays(+5) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForCrispLiveServers.ps1
C:\Work\PrePatching\approveUpdatesForWSinternalGISServers.ps1
#C:\Work\PrePatching\approveUpdatesForEcomServers.ps1
C:\Work\PrePatching\approveUpdatesForWSosiharcconfig01Server.ps1
C:\Work\PrePatching\approveUpdatesForExchange01.ps1
#C:\Work\PrePatching\approveUpdatesForTESTKEV.ps1

}
if ((isdayofmonth $datum.month $datum.year Tuesday 1) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryCrispLiveServers.ps1
C:\Work\PostPatching\GetPatchingHistoryWSInternalGISServers.ps1
#C:\Work\PostPatching\GetPatchingHistoryEcomServers.ps1
C:\Work\PostPatching\GetPatchingHistoryWSosiharcconfig01_Server.ps1
C:\Work\PostPatching\GetPatchingHistoryExchange01.ps1
C:\Work\PostPatching\GetPatchingHistoryTESTKEV.ps1


}
if ((isdayofmonth $datum.month $datum.year Wednesday 1) -eq (get-date -date $(get-date).adddays(+5) -format D))
{  
C:\Work\PrePatching\approveUpdatesForSoftwareAppsServers.ps1
}
if ((isdayofmonth $datum.month $datum.year Wednesday 1) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistorySoftwareAppsServers.ps1
}
if ((isdayofmonth $datum.month $datum.year Sunday 1) -eq (get-date -date $(get-date).adddays(+4) -format D))
{  
C:\Work\PrePatching\approveUpdatesForGMS_LIVE_Servers.ps1
C:\Work\PrePatching\approveUpdatesForElevate_LIVE_Servers.ps1
C:\Work\PrePatching\approveUpdatesForSDI1Servers.ps1
}
if ((isdayofmonth $datum.month $datum.year Sunday 1) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryGMS_Live_Servers.ps1
C:\Work\PostPatching\GetPatchingHistoryElevate_LIVE_Servers.ps1
C:\Work\PostPatching\GetPatchingHistorySDI1Servers.ps1
}
if ((isdayofmonth $datum.month $datum.year Tuesday 2) -eq (get-date -date $(get-date).adddays(+5) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForExchange02.ps1
}
if ((isdayofmonth $datum.month $datum.year Tuesday 2) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryExchange02.ps1
}
if ((isdayofmonth $datum.month $datum.year Thursday 2) -eq (get-date -date $(get-date).adddays(+5) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForMRDSTDEVservers.ps1
}
if ((isdayofmonth $datum.month $datum.year Thursday 2) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryOSIHMRDSPDEVServers.ps1
}
 if ((isdayofmonth $datum.month $datum.year Sunday 2) -eq (get-date -date $(get-date).adddays(+3) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForSanServer2Servers.ps1
C:\Work\PrePatching\approveUpdatesForVDIServers2.ps1
#C:\Work\PrePatching\approveUpdatesForwebdevServers.ps1
C:\Work\PrePatching\approveUpdatesForHelpdeskServers.ps1
C:\Work\PrePatching\approveUpdatesForSDI3Servers.ps1
C:\Work\PrePatching\approveUpdatesForFinanceServers.ps1
}
if ((isdayofmonth $datum.month $datum.year Sunday 2) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistorySanServer2Servers.ps1
C:\Work\PostPatching\GetPatchingHistoryVDI2Servers.ps1
#C:\Work\PostPatching\GetPatchingHistorywebdevServers.ps1
C:\Work\PostPatching\GetPatchingHistoryHelpdeskServers.ps1
C:\Work\PostPatching\GetPatchingHistorySDI3Servers.ps1
C:\Work\PostPatching\GetPatchingHistoryFinanceServers.ps1
}
if ((isdayofmonth $datum.month $datum.year Tuesday 3) -eq (get-date -date $(get-date).adddays(+5) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForCrispDEVServers.ps1
C:\Work\PrePatching\approveUpdatesForSanServerbackupServers.ps1
C:\Work\PrePatching\approveUpdatesForJIRAServer.ps1 
}
if ((isdayofmonth $datum.month $datum.year Tuesday 3) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryCrispDEVServers.ps1
C:\Work\PostPatching\GetPatchingHistoryJIRAServer.ps1
}
if ((isdayofmonth $datum.month $datum.year Wednesday 3) -eq (get-date -date $(get-date).adddays(+3) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForSanServer3Servers.ps1
C:\Work\PrePatching\approveUpdatesForSanServerbackupServers.ps1
}
if ((isdayofmonth $datum.month $datum.year Wednesday 3) -eq (get-date -format D))
{ 
C:\Work\PrePatching\approveUpdatesForSanServerbackupServers.ps1
}
if ((isdayofmonth $datum.month $datum.year Thursday 3) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistorySanServer3Servers.ps1
C:\Work\PostPatching\GetPatchingHistorySanServerbackupServers.ps1
}
 if ((isdayofmonth $datum.month $datum.year Sunday 3) -eq (get-date -date $(get-date).adddays(+3) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForSanServer1Servers.ps1
C:\Work\PrePatching\approveUpdatesForVDIServers1.ps1
C:\Work\PrePatching\approveUpdatesForSoftwareAppsDBServers.ps1
C:\Work\PrePatching\approveUpdatesForDBAServers.ps1
C:\Work\PrePatching\approveUpdatesForMailServers1.ps1
C:\Work\PrePatching\approveUpdatesForGMS_DEVTEST_Servers.ps1
C:\Work\PrePatching\approveUpdatesForSDI2Servers.ps1
}
if ((isdayofmonth $datum.month $datum.year Sunday 3) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistorySanServer1Servers.ps1
C:\Work\PostPatching\GetPatchingHistoryVDI1Servers.ps1
C:\Work\PostPatching\GetPatchingHistorySoftwareAppsDBServers.ps1
C:\Work\PostPatching\GetPatchingHistoryDBAServers.ps1
C:\Work\PostPatching\GetPatchingHistoryMailServers1.ps1
C:\Work\PostPatching\GetPatchingHistoryGMS_DEV_TEST_Servers.ps1
C:\Work\PostPatching\GetPatchingHistorySDI2Servers.ps1
}
 if ((isdayofmonth $datum.month $datum.year Monday 4) -eq (get-date -date $(get-date).adddays(+7) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForDataQualityServers.ps1
C:\Work\PrePatching\approveUpdatesForMailServers2.ps1
}
if ((isdayofmonth $datum.month $datum.year Monday 4) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryDataQualityServer.ps1
C:\work\PostPatching\GetPatchingHistoryMailServers2.ps1
}
 if ((isdayofmonth $datum.month $datum.year Tuesday 4) -eq (get-date -date $(get-date).adddays(+5) -format D))
{ 
C:\Work\PrePatching\approveUpdatesForCrispTestServers.ps1
C:\Work\PrePatching\approveUpdatesForWSosiharcconfig02Server.ps1
}
if ((isdayofmonth $datum.month $datum.year Tuesday 4) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryCrispTestServers.ps1
C:\Work\PostPatching\GetPatchingHistoryWSosiharcconfig02_Server.ps1
}
if ((isdayofmonth $datum.month $datum.year Thursday 4) -eq (get-date -format D))
{ 
C:\Work\PostPatching\GetPatchingHistoryEugeneTest.ps1
}