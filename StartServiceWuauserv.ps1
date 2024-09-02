   
    Invoke-Command -ScriptBlock { 
    
        if ((Get-Service -Name wuauserv).Status -ne "Running"){

            Start-Service -Name wuauserv
        }
    }
 