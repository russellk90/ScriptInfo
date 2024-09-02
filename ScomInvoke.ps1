Invoke-Command -ScriptBlock{
   Start-ScheduledTask -TaskName "ScomMaintMode" 
}
