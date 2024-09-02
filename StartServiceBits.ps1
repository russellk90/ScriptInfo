   
    Invoke-Command -ScriptBlock { 
    
        if ((Get-Service -Name BITS).Status -ne "Running"){

            Start-Service -Name BITS
        }
    }
 