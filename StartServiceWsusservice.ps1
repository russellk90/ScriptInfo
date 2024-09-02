   
    Invoke-Command -ScriptBlock { 
    
        if ((Get-Service -Name wsusservice).Status -ne "Running"){

            Start-Service -Name wsusservice
        }
    }
 