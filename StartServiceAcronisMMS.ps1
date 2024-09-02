   
    Invoke-Command -ScriptBlock { 
    
        if ((Get-Service -Name "mms").Status -ne "Running"){

            Start-Service -Name "mms"
        }
    }
 