$actionParams = @{
    Execute  = 'powershell.exe'
    Argument = 'C:\Patching\windowsUpdateAndLogging.ps1'
}

$action = New-ScheduledTaskAction @actionParams

#$settingsParams = @{
#   StartWhenAvailable = $true
  #  ExecutionTimeLimit = New-TimeSpan -Hours 12
   # MultipleInstances  = 'IgnoreNew'
#}

#$settings = New-ScheduledTaskSettingsSet @settingsParams

$credentialParams = @{
    UserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    Message = 'Enter credentials for the scheduled task to use.'
}

$credential = (Get-Credential @credentialParams).GetNetworkCredential()

$registerParams = @{
    TaskName = 'Patch_and_Reboot'
    Trigger = New-ScheduledTaskTrigger -At 07:00 -Once
    Action = $action
#   Settings = $settings
    User = $credential.UserName
    Password = $credential.Password
}

Register-ScheduledTask @registerParams 

# change gmsa user to serv name "osi.net\dcs_only_gmsa$"
#$princ = New-ScheduledTaskPrincipal -UserID "osi.net\corkfs05_gMSA$" -LogonType Password
#Set-ScheduledTask -TaskName "Patch_and_Reboot" -Principal $princ

