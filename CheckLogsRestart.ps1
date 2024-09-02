Get-EventLog -LogName System |
where {$_.EventId -eq 1074} |select-object -first 10 |
ForEach-Object {
$rv = New-Object PSObject | Select-Object Date, User, Action, process, Reason, ReasonCode
if ($_.ReplacementStrings[4]) {
$rv.Date = $_.TimeGenerated
$rv.User = $_.ReplacementStrings[6]
$rv.Process = $_.ReplacementStrings[0]
$rv.Action = $_.ReplacementStrings[4]
$rv.Reason = $_.ReplacementStrings[2]
$rv
}
} | Select-Object Process |ft -AutoSize