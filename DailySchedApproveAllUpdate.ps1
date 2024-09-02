


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

#$return= (isdayofmonth $datum.month $datum.year Tuesday 2)
echo $return
$datum=get-date
echo $datum
if ((isdayofmonth $datum.month $datum.year Tuesday 2) -eq (get-date -date $(get-date).adddays(-1) -format D))
{ C:\Work\PatchingUpdates\ApproveAllUpdateForMonth.ps1 }

echo Kev Testing daily sched approve all update work with serversus2_gmsa account  > "C:\KR_Testing.txt"

