Import-Module "C:\Program Files\Microsoft Monitoring Agent\Agent\MaintenanceMode.dll"
Start-SCOMAgentMaintenanceMode -Duration 300 -Force "Y" -Comment "Monthly Patching"

powershell -ExecutionPolicy Bypass -Command "Start-Sleep -Seconds 300"
