<# 
---------------------------------------------------------------------------------

This is a script that creates a Virtual Machine from a template OS. The user is
prompted to choose:
- a new VMname
- a template, OS Customisation, cluster, host on that cluster, resource pool,
  snd a datastore from a list of existing available choices 
- owner information about the VM
- the cores & amount of RAM to allocate the new VM
- a day of the week and week of the month to carry out server patches on
- whether they want a static IP or an IP dynamically assigned using DHCP
- whether they would like to add hard-drives to their new VM and if so, how many 
  and what size

The script then tracks the progress of the new VM deployment, notifying the user 
about important deployment milestones.


------------------
NECESSARY MODULES:
------------------
 - powercli
 - activedirectory
 - sqlserver
 - dhcpserver (comes with Windows Server 2012 R2 and above)


============================================================================
Modified and finalised by Dominick Cleary, James Kelleher, and Matthew Nolan
for the use of Ordnance Survey Ireland - 31/07/2019
============================================================================
---------------------------------------------------------------------------------
#>

# -> $Credentials is the Credential Object used to securely authenticate you to the server [PSCredential]
# -> $ConfigName is the name of the config file, must be in the same location as this script
param (
    [System.Management.Automation.PSCredential]$Credentials,
    [String]$ConfigName = "config.ini"
)
Import-module VMware.VimAutomation.Core
# Connects the user to a vcenter server, it catches errors and can prompt for new user inputs.
function Connect-toVCenterCred {
    try {
        Write-Host "Connecting to VC Server at $($ConfigData.VCenterAddress)" -ForegroundColor Yellow
        Connect-VIServer -Server $ConfigData.VCenterAddress -Credential $Credentials -ErrorAction Stop | Out-Null
    }
    catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.InvalidLogin] {
        Write-Host "ERROR: Cannot complete login due to an incorrect user name or password, exiting..." -ForegroundColor Red
        Exit-Script
    }
    catch [VMware.VimAutomation.Sdk.Types.V1.ErrorHandling.VimException.ViServerConnectionException] {
        Write-Host "ERROR: Could not resolve the requested VC server, exiting..." -ForegroundColor Red
        Exit-Script
    }
    catch {
        Write-Host "ERROR: Could not connect to VC Server, exiting..." -ForegroundColor Red
        Exit-Script
    }
    
    Write-Host "Sucessfully connected to VC Server" -ForegroundColor Green
}

# Exits the function safely by disonnecting from vcenter and deleting all variables created in the script
function Exit-Script {
    Disconnect-VIServer -Confirm:$false
    ((Compare-Object -ReferenceObject (Get-Variable).Name -DifferenceObject $DefaultVariables).InputObject).foreach{Remove-Variable -Name $_ -ErrorAction SilentlyContinue}
    exit
}

# Ensure user has entered something valid as text (Not empty or null & under a max length)
# -> $Message is the message presented to the user [String]
# -> $MaxLength (Optional) is the maximum length of input accepted [Int32]
# <- Returns Input [String]
function Get-ValidInput {
    param (
        [Parameter(Mandatory = $true)][String]$Message,
        [Int32]$MaxLength
    )
    do {
        $NoError = $true
        $Answer = Read-Host $Message
        if ([string]::IsNullOrEmpty($Answer)) {
            $NoError = $false
            Write-Host "ERROR: not a valid input, please try again`n" -ForegroundColor Red
        }
        elseif ($MaxLength -and ($answer.length -gt $MaxLength)) {
            $NoError = $false
            Write-Host "ERROR: You have exceeded the maximum input length of $($MaxLength)" -ForegroundColor Red
        }
    } until ($NoError)

    return $Answer
}

# Prompts user for VM name and ensures it is unique & valid (, doesn't already exist, under 15 characters, non-whitespace, etc.)
# <- Returns $VMName [String]
function Get-VMname {
    do {
        $NoError = $true
        $Answer = Get-ValidInput -message "`r`nEnter a name for this new VM" -maxLength 15
        # Get-VM retuns true if the VM name already exists
        if (Get-VM $Answer -ErrorAction 0) {
            $NoError = $false
            Write-Host "ERROR: a VM with this name already exists" -ForegroundColor Red
            # Prompts user to show them a list of existing VMs
            $ShowVMS = Get-YesOrNo "Would you like to see a list of existing VMs" 1
            if ($ShowVMS) {
                $VMList = Get-VM | Select-Object -Expand Name | Out-String
                Write-Host $VMList -ForegroundColor Yellow -NoNewline
            }
        }
        #Comparing the VM name to a regex expression disallowing invalid characters
        elseif (!($answer -match ("^(?=.*[a-zA-Z])[a-zA-Z0-9][a-zA-Z0-9\.\-\(\)]*[a-zA-Z0-9]$"))) {
            $NoError = $false
            Write-Host "ERROR: Invalid Name" -ForegroundColor Red
            if (Get-YesOrNo "Would you like to see naming restrictions?" 1) {
                Write-Host "`r`nAllowed Characters`r`n---------------------" -ForegroundColor Yellow
                Write-Host "Letters (a-z & A-Z)`r`nNumbers (0-9)`r`nPeriod (.)`r`nHyphen (-)`r`nParentheses ()" 
                Write-Host "`r`nSpecial Rules`r`n-------------" -ForegroundColor Yellow
                Write-Host "Cannot begin or end with hyphens, periods or parentheses`r`nMaximum Length of 15 characters`r`nMinimum Length 2 characters`r`nMust contain at least one letter`r`nMust be unique"
            }
        }
    } until ($NoError)

    return $Answer
}

# Prompts the user with a Yes/No question
# -> $Message is the message presented to the user [String]
# -> $DefaultChoice (Optional) is the default choice if no input is given, 1 Yes is default, 2 No is default, any other value is ignored [Int32]
# <- Returns $Answer [Boolean]
function Get-YesOrNo {
    param (
        [Parameter(Mandatory = $true)][String]$Message,
        [Int32]$DefaultChoice = 0
    )

    switch ($DefaultChoice) {
        1 {
            do {
                $Response = Read-Host "$($Message) [Y/n]"
                $EndLoop = $true
                if ($Response -eq "y" -or !$Response) {
                    $Answer = $true
                }
                elseif ($Response -eq "n") {
                    $Answer = $false
                }
                else {
                    $EndLoop = $false
                }
            } until ($EndLoop)
        }
        2 {
            do {
                $Response = Read-Host "$($Message) [y/N]"
                $EndLoop = $true
                if ($Response -eq "y") {
                    $Answer = $true
                }
                elseif ($Response -eq "n" -or !$Response) {
                    $Answer = $false
                }
                else {
                    $EndLoop = $false
                }
            } until ($EndLoop)
        }
        default {
            do {
                $Response = Read-Host "$($Message) [y/n]"
                $EndLoop = $true
                if ($Response -eq "y") {
                    $Answer = $true
                }
                elseif ($Response -eq "n") {
                    $Answer = $false
                }
                else {
                    $EndLoop = $false
                }
            } until ($EndLoop)
        }
    }

    return $Answer
}

# Allows user to choose between existing objects
# -> $List is the list of objects to choose from (templates, clusters, etc.) [String[]]
# -> $Object is the name of the object type for user output [String]
# <- Returns $ChosenObject [Object]
function Show-ExistingObjects {
    param (
        [Parameter(Mandatory = $true)][String[]]$List,
        [Parameter(Mandatory = $true)][String]$Object
    )

    $Answer = -1
    Write-Host "`r`nThis is a list of each" $Object "available:"
    # Display each option with the number beside them
    for ($i = 0; $i -lt $List.length; $i++) {
        Write-Host $($i + 1) ":" $List[$i] -ForegroundColor yellow
    }
    
    do {
        $NoError = $true
        $Answer = Read-Host "Choose by typing in the number beside your chosen" $Object
        if ($Answer -in 1..$List.length) { 
            $ChosenObject = $List[$Answer - 1] 
        }
        else {
            $NoError = $false
            Write-Host "ERROR: Choose a number within the range" -ForegroundColor Red
        }
    } until ($NoError)
    
    Write-Host $ChosenObject "chosen as" $Object "`n" -ForegroundColor Green
    return $ChosenObject
}

# Prompts the user to choose between a list of options
# -> $List is the list of numbers to choose from [String[]]
# -> $Name is the name of the option for user accessibility [String]
# -> $Message is the message presented to the user [String]
# <- Returns $Answer [Int32]
function Get-ChoiceFromList {
    param (
        [Parameter(Mandatory = $true)][String[]]$List,
        [Parameter(Mandatory = $true)][String]$Name,
        [Parameter(Mandatory = $true)][String]$Message
    )

    $Answer = -1

    Write-Host $Message
    for ($i = 0; $i -lt $List.Length; $i++) {
        Write-Host $($i + 1) ":" $List[$i] -ForegroundColor Yellow
    }

    do {
        $NoError = $true
        $Answer = Read-Host "Choose by typing in the number beside your chosen $($Name)"
        if (!($Answer -in 1..$List.Length)) {
            $NoError = $false
            Write-Host "ERROR: Choose a number within the range" -ForegroundColor Red
        }
    } until ($NoError)

    Write-Host "$($List[$Answer - 1]) Chosen" -ForegroundColor Green
    return $Answer
}

# Prompts user to choose the amount of RAM for their VM
# <- Returns $Mem [Int32]
function Get-MemAmount {
    do {
        try {
            $NoError = $true
            Write-Host "`r`nPlease select the amount of memory by entering a number"
            Write-Host "Between $($ConfigData.MinRAM)GB and $($ConfigData.MaxRAM)GB: " -ForegroundColor Yellow -NoNewline
            [int]$Mem = Read-Host
            if (!($Mem -in [Int32]$ConfigData.MinRAM..[Int32]$ConfigData.MaxRAM)) {
                Write-Host "ERROR: please choose a number within the range" -ForegroundColor Red
                $NoError = $false
            }
        }
        catch {
            $NoError = $false
            Write-Host "ERROR: not a valid input, please try again" -ForegroundColor Red
        }
    } until ($NoError -and ($Mem -in [Int32]$ConfigData.MinRAM..[Int32]$ConfigData.MaxRAM))
    Write-Host "$($Mem)GB Memory Chosen" -ForegroundColor Green

    return $Mem
}

# Confirms that the IP address the user has entered is within the exclusion zones 
# of the available scopes
# -> $IPAddress is the IP to be checked [String]
# <- [Boolean]
function Confirm-IPWithinRange {
    param (
        [Parameter(Mandatory = $true)][String]$IPAddress
    )
    $IPAddressDecimal = Convert-Ip2Decimal -IpAddress $IPAddress

    [String[]]$ScopeIds = Get-DhcpServerv4Scope -ComputerName $ConfigData.DHCPIP | Where-Object State -eq "Active" | Select-Object -ExpandProperty ScopeId

    foreach ($Id in $ScopeIds) {
        [Decimal]$StartRange = Convert-Ip2Decimal -IpAddress (Get-DhcpServerv4Scope -ScopeId $Id | Select-Object -ExpandProperty StartRange)
        [Decimal]$EndRange = Convert-Ip2Decimal -IpAddress (Get-DhcpServerv4Scope -ScopeId $Id | Select-Object -ExpandProperty EndRange)

        if ($IPAddressDecimal -ge $StartRange -and $IPAddressDecimal -le $EndRange) {
            [String[]]$ExclusionStartRanges = Get-DhcpServerv4ExclusionRange -ScopeId $Id | Select-Object -ExpandProperty StartRange
            [String[]]$ExclusionEndRanges = Get-DhcpServerv4ExclusionRange -ScopeId $Id | Select-Object -ExpandProperty EndRange

            for ($i = 0; $i -lt $ExclusionStartRanges.Length; $i++) {
                [Decimal]$ExclusionStartDecimal = Convert-Ip2Decimal -IpAddress $ExclusionStartRanges[$i]
                [Decimal]$ExclusionEndDecimal = Convert-Ip2Decimal -IpAddress $ExclusionEndRanges[$i]

                if ($IPAddressDecimal -ge $ExclusionStartDecimal -and $IPAddressDecimal -le $ExclusionEndDecimal) {
                    return $true
                }
            }
            return $false
        }
    }
    return $true
}

# Converts an IP address in a string format to a number
# -> $IpAddress is the IP to be converted
# <- Returns the converted IP [Decimal]
function Convert-Ip2Decimal {
    param (
        [Parameter(Mandatory = $true)][String]$IpAddress
    )

    return ([IPAddress][String]([IPAddress]$IpAddress)).Address
}

# This function allows the user to assign a static IP address to their new VM. 
# The user is prompted to pick:
# - an IP address
# - a subnet mask
# - a default gateway
# - primary and (optional) secondary DNS servers
# -> $IpAddress is the IP address to assign [String] 
# -> $SubnetMask is the subnet to assign [String] 
# -> $DefaultGateway is the default gateway to assign [String] 
# -> $Dns is an array of the primary and secondary DNS Servers [String[]] 
# <- An Object array of all valid inputs [Object[]]
function Get-StaticIp {
    param (
        [String]$IpAddress,
        [String]$SubnetMask,
        [String]$DefaultGateway,
        [String[]]$Dns = @("", "")
    )
    
    do {
        $InputCorrect = $false
        # Verify IP address is in a valid format
        do {
            $NoError = $true
            if (!$IpAddress) {
                $IpAddress = Read-Host "Enter your Static IP address"
            }
            Write-Host "Verifying if IP is available..." -ForegroundColor Yellow
            # Check if IP is neither null nor empty and if it is a syntactically valid IP
            if ([String]::IsNullOrEmpty($IpAddress) -or !(Test-ValidIp $IpAddress)) {
                $NoError = $false
                $IpAddress = $null
                Write-Host "ERROR: choose a valid IP address`r`n" -ForegroundColor Red
            }
            # Confirm that the IP is within an excusion range set in the DHCP Server
            elseif (!(Confirm-IPWithinRange $IpAddress)) {
                $NoError = $false
                $IpAddress = $null
                Write-Host "ERROR: That IP address is out of range`r`n" -ForegroundColor Red
            }
            # Ping the IP to ensure it is not taken
            elseif (Test-Connection -ComputerName $IpAddress -Quiet) {
                $NoError = $false
                $IpAddress = $null
                Write-Host "ERROR: That IP address is already taken`r`n" -ForegroundColor Red
            }
        } until($NoError)
        Write-Host $($IpAddress -as [IPAddress]) "chosen as IP`r`n" -ForegroundColor Green

        #Choose an IP subnet mask
        do {
            $NoError = $true
            if (!$SubnetMask) {
                $SubnetMask = Read-Host "Enter your Subnet mask"
            }
            if ([String]::IsNullOrEmpty($SubnetMask) -or !(Test-SubnetMask $SubnetMask)) {
                $NoError = $false
                $SubnetMask = $null
                Write-Host "ERROR: choose a valid Subnet mask`r`n" -ForegroundColor Red
            }
        } until($NoError)
        Write-Host $($SubnetMask -as [IPAddress]) "chosen as Subnet mask`r`n" -ForegroundColor Green

        #Choose a default gateway
        do {
            $NoError = $true
            if (!$DefaultGateway) {
                $DefaultGateway = Read-Host "Enter your Default Gateway"
            }
            if ([String]::IsNullOrEmpty($DefaultGateway) -or !(Test-ValidIp $DefaultGateway)) {
                $NoError = $false
                $DefaultGateway = $null
                Write-Host "ERROR: default gateway is in an invalid format`r`n" -ForegroundColor Red
            }
            # This checks if the Default gateway is part of the same subnet as the IP Address
            elseif ((($IpAddress -as [IPAddress]).address -band ($SubnetMask -as [IPAddress]).Address) -ne (($DefaultGateway -as [IPAddress]).Address -band ($SubnetMask -as [IPAddress]).Address)) {
                $NoError = $false
                $DefaultGateway = $null
                Write-Host "ERROR: default gateway and IP address must be within the same subnet`r`n" -ForegroundColor Red
            }
        } until($NoError)
        Write-Host $($DefaultGateway -as [IPAddress]) "chosen as Default Gateway`r`n" -ForegroundColor Green

        #Choose a primary DNS server
        do {
            $NoError = $true
            if (!$Dns[0]) {
                $Dns[0] = Read-Host "Enter primary DNS server"
            }
            if ([String]::IsNullOrEmpty($Dns[0]) -or !(Test-ValidIp $Dns[0])) {
                $NoError = $false
                $Dns[0] = $null
                Write-Host "ERROR: choose a valid primary DNS`r`n" -ForegroundColor Red
            }
        } until ($NoError)

        #(Optional) choose a secondary DNS server
        do {
            $NoError = $true
            if (!$Dns[1]) {
                $Dns[1] = Read-Host "Enter secondary DNS server (leave blank for none)"
            }
            # Secondary DNS can be null because it is optional
            elseif (!(Test-ValidIp $Dns[1])) {
                $NoError = $false
                $Dns[1] = $null
                Write-Host "ERROR: choose a valid secondary DNS`r`n" -ForegroundColor Red
            }
        } until($NoError)

        Write-Host $($Dns[0] -as [IPAddress]) "chosen as primary DNS" -ForegroundColor Green
        if (![String]::IsNullOrEmpty($Dns[1])) {
            Write-Host $($Dns[1] -as [IPAddress]) "chosen as secondary DNS" -ForegroundColor Green
        }
        # Adds a blank line after the confirmation
        Write-Host ""

        Write-Host "IP Address - $($IpAddress)" -ForegroundColor Yellow
        Write-Host "Subnet Mask - $($SubnetMask)" -ForegroundColor Yellow
        Write-Host "Default Gateway - $($DefaultGateway)" -ForegroundColor Yellow
        Write-Host "Primary DNS - $($Dns[0])" -ForegroundColor Yellow
        if (![String]::IsNullOrEmpty($Dns[1])) {
            Write-Host "Secondary DNS - $($Dns[1])" -ForegroundColor Yellow
        }
        else {
            Write-Host "Secondary DNS - n/a" -ForegroundColor Yellow
        }
        $InputCorrect = Get-YesOrNo "Are these details correct?" 1
        # Resets all the variables
        if (!$InputCorrect) {
            $IpAddress = $null
            $SubnetMask = $null
            $DefaultGateway = $null
            $Dns[0] = $null
            $Dns[1] = $null
        }
    } until ($InputCorrect)

    Write-Host "Static IP chosen successfully" -ForegroundColor Green
    # Return all valid inputs within an Object array
    return $IpAddress, $SubnetMask, $DefaultGateway, $Dns[0], $Dns[1]
}

# Checks whether the subnet mask is valid (all 1s followed by all 0s)
# -> $SubnetMask is the subnet mask to be checked [String]
# <- [Boolean]
function Test-SubnetMask {
    param (
        [Parameter(Mandatory = $true)][String]$SubnetMask
    )
    if (!(Test-ValidIp $SubnetMask)) {
        return $false
    }
    # Convert Subnet Mask into binary
    $BinarySubnet = [Convert]::toString(([System.Net.IPAddress][String]($SubnetMask -as [System.Net.IPAddress]).Address).Address, 2)

    # If subnet contains '01' it is not a valid subnet
    if ($BinarySubnet.contains("01") -or $BinarySubnet.length -lt 32) {
        return $false
    }
    else {
        return $true
    }
}

# Checks whether the IP address entered is valid
# -> $IpAddress is the IP to be checked
# <- [Boolean]
function Test-ValidIp {
    param (
        [Parameter(Mandatory = $true)][String]$IpAddress
    )
    # Converts IP String to IPAddress object, if successful returns true, otherwise false
    return $IpAddress -as [System.Net.IPAddress] -as [Boolean]
}

# Sorts two arrays by sorting the first array (highest to lowest) and mirrroring those changes in the second array, it can also sort sections of an array
# $Arr1 and $Arr2 must be the same size
# -> $Arr1, the first array 
# -> $Arr2, the second array
# -> $StartIndex, the index where the sorting begins (Default = 0) [Int32]
# -> $EndIndex, the index where the sorting ends (Default = Last Index) [Int32]
# <- $Arr1, the first array, sorted
# <- $Arr2, the second array, sorted in the same order as $Arr1
function Sort-TwoArrays {
    param (
        [Parameter(Mandatory = $true)]$Arr1,
        [Parameter(Mandatory = $true)]$Arr2,
        [Int32]$StartIndex = 0,
        [Int32]$EndIndex = $Arr1.Count
    )

    for ($i = 0; $i -lt $EndIndex - $StartIndex; $i++) {
        for ($j = $StartIndex; $j -lt $EndIndex - ($i + 1); $j++) {
            if ($Arr1[$j] -lt $Arr1[$j + 1]) {
                $Temp = $Arr1[$j]
                $Arr1[$j] = $Arr1[$j + 1]
                $Arr1[$j + 1] = $Temp
                
                $Temp = $Arr2[$j]
                $Arr2[$j] = $Arr2[$j + 1]
                $Arr2[$j + 1] = $Temp
            }
        }
    }

    return $Arr1, $Arr2
}

# groups a list of datastores by their names and then subsorts their freespace
# -> $DSName, the array of names of datastores [String[]]
# -> $DSSpace, the array of datastore free space, sharing the same indices as $DSName [Decimal[]]
# <- $DSname, grouped and sorted [String[]]
# <- $DSspace, grouped and sorted [Decimal[]]
function Sort-Datastores {
    param (
        [Parameter(Mandatory = $true)][String[]]$DSName,
        [Parameter(Mandatory = $true)][Decimal[]]$DSSpace
    )

    # Sort the entire array first based on the names
    $DSName, $DSSpace = Sort-TwoArrays $DSName $DSSpace

    [Regex]$Regex = "^[^-]+"
    for ($i = 0; $i -lt $DSName.Count; $i = $j + 1) {
        $Matched = $Regex.Match($DSName[$i]).Value
        $j = $i + 1
        # Increment j as long as the next datastore shares the same string before the 1st hyphen
        while ($Matched -eq $Regex.Match($DSName[$j]).Value) { $j++ }

        $DSSpace, $DSName = Sort-TwoArrays $DSSpace $DSName $i $j
    }

    return $DSName, $DSSpace
}

# Allows the user to select the datastore for the VM
# -> $HostName is the VMHost that the VM is being deployed to [String]
# -> $TemplateUsed is the template used [String]
# <- Returns $DatastoreUsed [String]
function Select-Datastore {
    param (
        [Parameter(Mandatory = $true)][String]$HostName,
        [Parameter(Mandatory = $true)][String]$TemplateUsed
    )

    $tp = Get-Template -Name $TemplateUsed
    $var = $tp.ExtensionData.Storage.PerDatastoreUsage | Select-Object -ExpandProperty Committed
    # Converts the Bytes into Gigabytes
    [Decimal]$SizeOfHD = ($($var / [math]::pow(1024, 3)))
    Write-Host "This is a list of each datastore available (The chosen template is $([math]::round($SizeOfHD, 2))GB):"

    [String[]]$DatastoreNames = Get-VMHost -Name $HostName | Get-Datastore | Select-Object -ExpandProperty Name
    [Decimal[]]$DatastoreFreeSpace = Get-VMHost -Name $HostName | Get-Datastore | Select-Object -ExpandProperty FreeSpaceGB
    $DatastoreNames, $DatastoreFreeSpace = Sort-Datastores -DSName $DatastoreNames -DSSpace $DatastoreFreeSpace
    # Dynamic Array of usable datastores
    $UsableDatastores = New-Object System.Collections.ArrayList

    $Count = 0;
    $NoDatastores = $true
    [String]$DatastoreUsed = ""

    for ($i = 0; $i -lt $DatastoreNames.length; $i++) {
        if ($DatastoreFreeSpace[$i] -ge $SizeOfHD) {
            Write-Host $($Count++ + 1) ":" $DatastoreNames[$i] "($([math]::Round($DatastoreFreeSpace[$i], 2))GB)" -ForegroundColor Yellow
            $UsableDatastores.Add($DatastoreNames[$i]) > $null
            $NoDatastores = $false
        } 
    }
    if ($NoDatastores) {
        Write-Host "ERROR: There are no datastores with enough free space, exiting" -ForegroundColor Red
        Exit-Script
    }

    do {
        $NoError = $true
        $Answer = Read-Host "Choose by typing in the number beside your chosen datastore"
        if ($Answer -in 1..$UsableDatastores.Count) { 
            $DatastoreUsed = $UsableDatastores[$Answer - 1] 
        }
        else {
            $NoError = $false
            Write-Host "ERROR: Choose a number within the range" -ForegroundColor Red
        }
    } until ($NoError)
    Write-Host "$($DatastoreUsed) chosen as datastore" -ForegroundColor Green

    return $DatastoreUsed
}

# Allows the user to add hard-drives to their VM
# -> $VMName is the name of the the VM to add HDs to [String]
function Add-HardDrives {
    param (
        [Parameter(Mandatory = $true)][String]$VMName
    )

    # Initialize the variables
    $Answer = -1
    [Int32]$AmountOfHD = -1
    
    Write-Host "`r`nEntering Add Hard drives dialog"
    Write-Host "Retrieving data from host..." -ForegroundColor Yellow
    # Gets an array of drive letters already in use
    try {
        $DriveLettersString = Invoke-Command -ComputerName $VMName -Credential $Credentials -ScriptBlock { Get-Volume | Select-Object -ExpandProperty DriveLetter | Out-String }
    }
    catch {
        Write-Host "ERROR: Could not retrieve data from host. Exiting function`r`n" -ForegroundColor Red
        return $null
    }
    # Beginning and end of String is empty to ignore them
    $null, [String[]]$UsedDriveLetters = $DriveLettersString.Split("`n").Trim()

    do {
        $NoError = $true
        $AmountOfHD = Read-Host "`r`nEnter the amount of additional hard drives you need (maximum $($ConfigData.MaxExtraHD))"
        if (($AmountOfHD -lt 1) -or ($AmountOfHD -gt [Int32]$ConfigData.MaxExtraHD)) {
            $NoError = $false
            Write-Host "ERROR: Select a number within range" -ForegroundColor Red
        }
    } until ($NoError)

    # Initialize Arrays
    for ($i = 0; $i -lt $AmountOfHD; $i++) {
        [Decimal[]]$HDSizes += 0
        [String[]]$DatastoreUsed += ""
        [String[]]$DriveLetters += ""
    }

    for ($i = 0; $i -lt $AmountOfHD; $i++) {
        [String[]]$DatastoreNames = Get-VMHost -VM $VMName | Get-Datastore | Select-Object -ExpandProperty Name
        [Decimal[]]$DatastoreFreeSpace = Get-VMHost -VM $VMName | Get-Datastore | Select-Object -ExpandProperty FreeSpaceGB
        $DatastoreNames, $DatastoreFreeSpace = Sort-Datastores -DSName $DatastoreNames -DSSpace $DatastoreFreeSpace
        # Dynamic Array of usable datastores for each hard drive
        $UsableDatastores = New-Object System.Collections.ArrayList

        do {
            $Count = 0;
            $Empty = $true

            do {
                $NoError = $true
                $Answer = Read-Host "`r`nEnter size in GB of HD $($i + 1) (maximum $($ConfigData.MaxHDSize)GB)"
                if (!($Answer -in 1..[Int32]$ConfigData.MaxHDSize)) {
                    $NoError = $false
                    Write-Host "ERROR: Select a number within range" -ForegroundColor Red
                }
                else {
                    $HDSizes[$i] = $Answer
                }
            } until ($NoError)

            Write-Host "`r`nThis is a list of each available datastore with at least $($HDSizes[$i])GB free space:"
            for ($j = 0; $j -lt $DatastoreNames.length; $j++) {
                if ($DatastoreFreeSpace[$j] -ge $HDSizes[$i]) {
                    Write-Host $($Count++ + 1) ":" $DatastoreNames[$j] "($([math]::Round($DatastoreFreeSpace[$j], 2))GB)" -ForegroundColor Yellow
                    $UsableDatastores.Add($DatastoreNames[$j]) > $null
                    $Empty = $false
                } 
            }
            if ($Empty) {
                Write-Host "ERROR: There are no datastores with enough free space, enter your HD Size again" -ForegroundColor Red
                if (Get-YesOrNo "Would you like to see a list of available datastores?" 1) {
                    for ($j = 0; $j -lt $DatastoreNames.length; $j++) {
                        Write-Host $($Count++ + 1) ":" $DatastoreNames[$j] "($([math]::Round($DatastoreFreeSpace[$j], 2))GB)" -ForegroundColor Yellow
                    }
                }
            }
        } until (!$Empty)

        do {
            $NoError = $true
            $Answer = Read-Host "Choose by typing in the number beside your chosen datastore"
            if ($Answer -in 1..$UsableDatastores.Count) { 
                $DatastoreUsed[$i] = $UsableDatastores[$Answer - 1] 
            }
            else {
                $NoError = $false
                Write-Host "ERROR: Choose a number within the range" -ForegroundColor Red
            }
        } until ($NoError)
        Write-Host "Datastore $($DatastoreUsed[$i]) chosen`r`n" -ForegroundColor Green
        Write-Host "Creating VMDK..." -ForegroundColor Yellow
        Get-VM $VMName | New-HardDisk -CapacityGB $HDSizes[$i] -Persistence persistent -Datastore $DatastoreUsed[$i] -Confirm:$false | Out-Null
        # Sleep for 20 seconds to allow the free space to be updated in vcenter, skip for the last HD added
        if ($i -ne ($AmountOfHD - 1)) {
            Start-Sleep 10
        }
        Write-Host "VMDK Successfully created" -ForegroundColor Green

        if (Get-YesOrNo "Do you want to format the Hard Disk? (Filesystem: NTFS)" 1) {
            do {
                $NoError = $true
                $Answer = Read-Host "Choose the drive letter of the Hard Disk [A-Z]"

                if ($Answer.Length -eq 1 -and ($Answer -match "^[a-zA-Z]")) {
                    if ($UsedDriveLetters.Contains($Answer.ToUpper())) {
                        $NoError = $false
                        Write-Host "ERROR: $($Answer.ToUpper()) is already taken as a drive letter`r`n" -ForegroundColor Red
                        if (Get-YesOrNo "Would you like to see a list of existing Drive Letters?" 1) {
                            foreach ($Letter in $UsedDriveLetters) {
                                Write-Host $Letter -ForegroundColor Yellow
                            }
                        }
                    }
                    else {
                        $DriveLetters[$i] = $Answer.ToUpper()
                        $UsedDriveLetters += $Answer.ToUpper()
                        Write-Host "$($Answer.ToUpper()) chosen as drive letter`r`n" -ForegroundColor Green
                    }
                }  
                else {
                    $NoError = $false
                    Write-Host "ERROR: choose a drive letter between A-Z" -ForegroundColor Red 
                }
            } until ($NoError)

            Write-Host "Formatting Drive..." -ForegroundColor Yellow
            try {
                Invoke-Command -ComputerName (Get-VM $VMName).Guest.HostName -Credential $Credentials -ArgumentList @($DriveLetters[$i], $HDSizes[$i]) -ScriptBlock {
                    # Getting the Disk number
                    [Int32]$DiskNumber = Get-Disk | Where-Object PartitionStyle -eq RAW | Where-Object Size -eq $($args[1] * ([math]::pow(1024, 3))) | Select-Object -ExpandProperty number
                    Initialize-Disk -Number $DiskNumber 
                    New-Partition -DiskNumber $DiskNumber -UseMaximumSize -DriveLetter $args[0] | Format-Volume -FileSystem NTFS -Confirm:$false | Out-Null
                }
            }
            catch {
                Write-Host "ERROR: Could not format Virtual Disk" -ForegroundColor Red
            }
            Write-Host "Drive Formatted Successfully`r`n" -ForegroundColor Green
        }
    }
}

# Displays what stage of deployment the VM is at.
# Tracks the initial boot, and two more reboots of the VM.
function Show-DeploymentProcess {
    $Timer = [Diagnostics.Stopwatch]::StartNew()
    $StageCounter = 0;
    $CurrentToolStatus = "toolsNotRunning"
    $ShowMessage = $true

    [String[]]$FirstMessage = "`r`nWaiting for the initial boot of $($VMName)...`r`n", "Preparing for the first reboot of $($VMName)...`r`n", "First reboot of $($VMName) complete`r`n", "Preparing for the second reboot of $($VMName)...`r`n", "Second reboot of $($VMName) complete`r`n", "Customising VM...`r`n"

    [String[]]$SecondMessage = "Initial boot of $($VMName) complete`r`n", "First reboot of $($VMName) in progress...`r`n", "", "Second reboot of $($VMName) in progress...`r`n"

    while ($StageCounter -lt 7 -and $Timer.Elapsed.TotalSeconds -le [Int32]$ConfigData.Timeout) {
        if ($ShowMessage -and (($StageCounter -eq 2) -or ($StageCounter -eq 4))) {
            Write-Host $FirstMessage[$StageCounter] -ForegroundColor Green -NoNewline
            $ShowMessage = $false
        }
        elseif ($ShowMessage) {
            Write-Host $FirstMessage[$StageCounter] -ForegroundColor Yellow -NoNewline
            $ShowMessage = $false
        }
        $PercentComplete = ($StageCounter / 7) * 100
        [int]$SecondsRemaining = [Int32]$ConfigData.Timeout * ((100 - (($Timer.Elapsed.TotalSeconds / [Int32]$ConfigData.Timeout) * 100)) / 100)
        Write-Progress -Activity "Deployment of $($VMName) in progress..." -Status "$($SecondsRemaining)s remaining before timeout occurs" -PercentComplete $PercentComplete
        $ToolsStatus = (Get-VM -name $VMName).ExtensionData.Guest.ToolsStatus

        if ($ToolsStatus -ne $CurrentToolStatus) {
            # If tools status changes increment the counter and print a progess message
            $CurrentToolStatus = $ToolsStatus
            if (($StageCounter) -eq 0) {
                Write-Host $SecondMessage[$StageCounter] -ForegroundColor Green -NoNewline
            }
            else {
                Write-Host $SecondMessage[$StageCounter] -ForegroundColor Yellow -NoNewline
            }
            $StageCounter++
            $ShowMessage = $True
            Start-Sleep 4
        }
        Start-Sleep 1
    }

    Write-Host "Finishing up..." -ForegroundColor Yellow
    
    while (!(Test-Connection -ComputerName (Get-VM $VMName).Guest.HostName -Quiet) -and $Timer.Elapsed.TotalSeconds -le [Int32]$ConfigData.Timeout) {
        [int]$SecondsRemaining = [Int32]$ConfigData.Timeout * ((100 - (($Timer.Elapsed.TotalSeconds / [Int32]$ConfigData.Timeout) * 100)) / 100)
        Write-Progress -Activity "Deployment of $($VMName) in progress..." -Status "$($SecondsRemaining)s remaining before timeout occurs" -PercentComplete 99
    }

    if ($Timer.Elapsed.TotalSeconds -gt [Int32]$ConfigData.Timeout) {
        Get-FatalErrorDetected -Message "Deployment of $($VMName) took more than $([int]([Int32]$ConfigData.Timeout/60)) minutes, manually check if everything OK"
    }
    Write-Progress -Activity "Deployment of $($VMName) in progress..." -Status "Finished" -PercentComplete 100 -Completed
    Write-Host "$($VMName) successfully customised" -ForegroundColor Green
}

# Show the user a dialog to determine what to do after a fatal error is detected
# -> $Message is the message to display to the user [String]
# -> $Question is the question to display to the user (Default = "Do you want to continue, quit or delete VM & quit?") [String]
# -> $Choices is the choice presented to the user (Default = "&Continue", "&Quit", "&Delete & Quit") [String[]]
# -> $$DefaultChoice is the default choice to pick (Default = -1) [Int32]
function Get-FatalErrorDetected {
    param (
        [Parameter(Mandatory = $true)][String]$Message,
        [String]$Question = "Do you want to continue, quit or delete VM & quit?",
        [String[]]$Choices = @("&Continue", "&Quit", "&Delete & Quit"),
        [Int32]$DefaultChoice = -1
    )

    $Decision = $Host.UI.PromptForChoice($Message, $question, $choices, $DefaultChoice)
    
    switch ($Decision) {
        0 { Write-Host "Continuing..." -ForegroundColor Yellow }
        1 {
            Write-Host "Quitting..." -ForegroundColor Red
            Exit-Script
        }
        2 {
            .\DeleteNamedVirtualMachineAndCleanUp.ps1 -ServerToDel $VMName -Credentials $Credentials
            Exit-Script
        }
    }
}

$DefaultVariables = $(Get-Variable).Name

# Reads in the config from the configuration file
$CurrentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
[String]$ConfigDir = $CurrentDir + "\" + $ConfigName
$ConfigData = (Get-Content $ConfigDir) -replace ("\\", "\\") -replace ("\[.*\]", "") -replace (";.*$", "") | ConvertFrom-StringData

Set-PowerCliConfiguration -proxypolicy noproxy -invalidcertificateaction ignore -Confirm:$false | Out-Null
## Connect to VC Server
if (!$Credentials) {
    $Username = Get-ValidInput "User"
    $Credentials = New-Object System.Management.Automation.PSCredential($Username, (Read-Host "Password for user $Username" -AsSecureString))
}
Connect-toVCenterCred

$VMName = Get-VMname

## Get array & user's choice of all templates available in vCenter
$TemplateList = @()
$TemplateList = Get-Template | Select-Object -ExpandProperty Name
$VMTemplate = Show-ExistingObjects $TemplateList "template"

## Get array & user's choice of all VM OS Customizations available in vCenter that can be applied to the template chosen
## NOTE - only shows Template OS specific customisations if the template & the customizations specify what year their OS is
[string[]]$VMOScustListAll = Get-OSCustomizationSpec | Select-Object -ExpandProperty Name | Sort-Object
[string[]]$VMOScustListApplicable = @()
if ($VMTemplate -match '.*20\d\d.*') {
    $year = [regex]::match($VMTemplate, '20\d\d')
    forEach ($VMOScust in $VMOScustListAll) {
        if ($VMOScust -match $year) { [string[]]$VMOScustListApplicable += $VMOScust }
    }
}
else {
    $VMOScustListApplicable = $VMOScustListAll
}

if(!$VMOScustListApplicable) {
    Write-Host "There are no available OS Customizations, exiting..." -ForegroundColor Red
    Exit-Script
}
$OSCustomization = Show-ExistingObjects $VMOScustListApplicable "OS customisation"

## Get array & user's choice of each cluster available in vCenter
$ClusterList = @()
$ClusterList = Get-Cluster | Select-Object -ExpandProperty Name | Sort-Object
if(!$ClusterList) {
    Write-Host "There are no available Clusters, exiting..." -ForegroundColor Red
    Exit-Script
}
$VMCluster = Show-ExistingObjects $ClusterList "cluster"

## Get array & user's choice of each Resource pool avaiable
$RPListTemp = @()
$RPListTemp = Get-ResourcePool -Location $VMCluster | Select-Object -ExpandProperty Name | Sort-Object
$RPList = $RPListTemp | Where-Object { !($_ -match "^Resources$") }
if(!$RPList) {
    Write-Host "There are no available Reource Pools, exiting..." -ForegroundColor Red
    Exit-Script
}
$VMResourcePool = Show-ExistingObjects $RPList "resource pool"

## Get array & user's choice of each Host available
$HostList = @()
$HostList = Get-VMHost -Location $VMCluster | Where-Object ConnectionState -eq "Connected" | Select-Object -ExpandProperty Name | Sort-Object
if(!$HostList) {
    Write-Host "There are no available Hosts, exiting..." -ForegroundColor Red
    Exit-Script
}
$VMHost = Show-ExistingObjects $HostList "host"

if (Get-YesOrNo "Would you like to change the network (Default: $($ConfigData.DefaultNetwork))" 2) {
    $VMNetwork = Show-ExistingObjects (Invoke-Expression -Command $ConfigData.NetworkList) "network"
}
else {
    $VMNetwork = $ConfigData.DefaultNetwork
    Write-Host "$VMNetwork chosen as network`r`n" -ForegroundColor Green
}

$VMDatastore = Select-Datastore -HostName $VMHost -TemplateUsed $VMTemplate

## User's choice of core count
[String[]]$CPUList = @()
for ($i = [Int32]$ConfigData.MinCPUs; $i -le [Int32]$ConfigData.MaxCPUs; $i++) {
    if ($i -eq 1) {
        $CPUList += "1 CPU"
    }
    else {
        $CPUList += "$i CPUs"
    }
}
$CoreNum = Get-ChoiceFromList -List $CPUList -Message "`r`nSelect the amount of CPUs for your VM:" -Name "CPU Count"

## Allow user to choose size of RAM
$MemAmount = Get-MemAmount

## Allow user to setup a static IP for the VM
if ($SetStaticIp = Get-YesOrNo "`r`nSetup a static IP?") {
    $StaticIpList = Get-StaticIp
}

## Asks if the user would like to add additional Hard drives, It asks with the rest of the user input but cannot be run until after the VM is deployed
$ChosenToAddHD = Get-YesOrNo "`r`nAdd additional Hard Drives to your VM? (Dialog will begin after deployment is finished)"

## This information goes in the database
$PrimaryOwner = Get-ValidInput -message "`r`nEnter primary owner's name for this VM" -maxLength 64
$SecondaryOwner = Get-ValidInput -message "Enter secondary owner's name for this VM" -maxLength 64
$HelpdeskID = Get-ValidInput -message "Enter the helpdesk ID for this VM" -maxLength 64
$Description = Get-ValidInput -message "Enter a detailed description of what this VM's function or role will be" -maxLength 256

[String[]]$DayList = "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
$DayOfWeek = Get-ChoiceFromList -List $DayList -Message "`r`nSelect a day of the week for patching:" -Name "day"

[String[]]$WeekList = "Week 1", "Week 2", "Week 3", "Week 4"
$WeekOfMonth = Get-ChoiceFromList -List $WeekList -Message "`r`nSelect a week of the month for patching:" -Name "week"
    
[String[]]$StatusList = "Production", "Test", "Development"
$Status = Get-ChoiceFromList -List $StatusList -Message "`r`nSelect the status of the VM:" -Name "status"

$loggedonUser = $(whoami)

try {
    if ($SetStaticIp) {
        # Clone the chosen customizaton and change the NIC mapping
        $ClonedOSCust = Get-OSCustomizationSpec $OSCustomization | New-OSCustomizationSpec -Name "$($OSCustomization)_$($VMName)"
        Set-OSCustomizationNicMapping -OSCustomizationNicMapping ($ClonedOSCust | Get-OSCustomizationNicMapping) -IpMode UseStaticIp -IpAddress $StaticIpList[0] -SubnetMask $StaticIpList[1] -DefaultGateway $StaticIpList[2] -Dns $StaticIpList[3], $StaticIpList[4] | Out-Null

        Write-Host "Creating a new VM $($VMName)..." -ForegroundColor Yellow
        New-VM -Name $VMName -Template $VMTemplate -VMHost $VMHost -Datastore $VMDatastore -OSCustomizationSpec $ClonedOSCust -ResourcePool $VMResourcePool | Out-Null
        # Clean-up the cloned OS Customization spec
        Remove-OSCustomizationSpec -CustomizationSpec $ClonedOSCust -Confirm:$false | Out-Null
    }
    else {
        Write-Host "Creating a new VM $($VMName)..." -ForegroundColor Yellow
        New-VM -Name $VMName -Template $VMTemplate -VMHost $VMHost -Datastore $VMDatastore -OSCustomizationSpec $OSCustomization -ResourcePool $VMResourcePool | Out-Null
    }
}
catch {
    Get-FatalErrorDetected -Message "An Error occurred while creating the VM"
}
# Need this to ensure that VCenter registers the new VM fully
Start-Sleep 10

# Connect VM to network
Write-Host "Connecting the VM to the network..." -ForegroundColor Yellow
Get-VM $VMName | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $VMNetwork -Confirm:$false | Out-Null

## changing the cores & memory of the VM
Write-Host "Customising core count..." -ForegroundColor Yellow
Get-VM $VMName | Set-VM -NumCpu $CoreNum -Confirm:$false | Out-Null

Write-Host "Customising RAM size..." -ForegroundColor Yellow
Get-VM $VMName | Set-VM -MemoryGB $MemAmount -Confirm:$false | Out-Null

Write-Host "Starting VM $($VMName)..." -ForegroundColor Yellow
Start-VM -vm $VMName -Confirm:$false | Out-Null

# This is where we track deployment progress
Show-DeploymentProcess

# This is where we can add extra Hard Drives if chosen
if ($ChosenToAddHD) {
    Add-HardDrives -VMName $VMName
}

Get-ADComputer $VMName -Credential $Credentials | Move-ADObject -TargetPath $ConfigData.ADComputerPath -Credential $Credentials

#create the temporary group assignment and add it to local admins on the server.
$LocalAdminGroup = $VMName + "_LOC_ADM"
# Write-Output $LocalAdminGroup 

$Description = $VMName + " temporary group assignments group"
New-ADGroup –name $LocalAdminGroup –groupscope Global –path $ConfigData.ADGroupPath -Description $Description -Credential $Credentials
$LocalAdminGroup = $ConfigData.DomainName + "\" + $LocalAdminGroup 
Start-Sleep 20
Invoke-Command -ComputerName (Get-VM $VMName).Guest.HostName -Credential $Credentials -ScriptBlock {
    # This spits out an error if target computer is running powershell < 5.0
    Add-LocalGroupMember -Group "Administrators" -Member $using:LocalAdminGroup
    gpupdate /force 
    wuauclt.exe /resetauthorization
    wuauclt.exe /detectnow
    wuauclt.exe /reportnow
}

# For more recent OS VMs (Windows 10 ... ) wuauclt /detectnow has been deprecated and no longer functions
#if ($recentOS) {
try {
    Invoke-Command -ComputerName (Get-VM $VMName).Guest.HostName -Credential $Credentials -ScriptBlock { 
        (New-Object -ComObject Microsoft.Update.AutoUpdate -ErrorAction SilentlyContinue).DetectNow() 
    } -ErrorAction SilentlyContinue
}
catch {
    # ignore exception for older OS VMs
    Continue
}
#}                
# This line runs a scheduled task on the new VM that downloads & installs updates, then reboots
Invoke-Command -ComputerName (Get-VM $VMName).Guest.HostName -Credential $Credentials -Scriptblock {
    schtasks /run /tn "Patch and Reboot"
}


# Invoke-Command -ComputerName $VMName -Credential $Credentials -ScriptBlock {C:\Patching\windowsUpdateAndLogging.ps1 }
# Invoke-Command -ComputerName $VMName -Credential $Credentials -FilePath C:\Patching\checkInToWSUSCopy.ps1

## get server
#$server = Get-WsusServer -Name "osihserversus02" -PortNumber 8530
# $VMName= $VMName + ".osi.net"
#$computer = $server.GetComputerTargetByName($VMName)
## list all TargetGroups with ID
#$server.GetComputerTargetGroups() | ft Name, Id

## add to group (you need the ID from the list above)
#$newGroup = $server.GetComputerTargetGroup("14a41b08-4286-4878-bc80-79ce4395389c")
#$newGroup.AddComputerTarget($computer)

$Guid = New-Guid
$date = Get-Date
    
$insertquery = "
INSERT INTO [dbo].[$($ConfigData.TableName)] 
    ([ServerID],
    [ServerName],
    [ServerType],
    [ServiceTag],
    [OperatingSystem],
    [DateCreated],
    [PrimaryOwner],
    [SecondaryOwner],
    [HelpDeskCallID],
    [Description],
    [WeekToPatch],
    [DayToPatch],
    [Status],
    [CreatedBy]) 
VALUES
    ('$Guid',
    '$VMName',
    'Virtual',
    'na',
    '$VMTemplate',
    '$date',
    '$PrimaryOwner',
    '$SecondaryOwner',
    '$HelpdeskID',
    '$Description',
    '$WeekOfMonth',
    '$DayOfWeek',
    '$Status',
    '$loggedonUser')
GO"

Write-Host "Adding details to the server database..." -ForegroundColor Yellow
Invoke-SQLcmd -ServerInstance $ConfigData.ServerInstance -query $insertquery -Database $ConfigData.DatabaseName

#This cannot work without keeping unsecure remote computer credentials in a file
#Write-Host "Creating a task on the WSUS server for patching purposes..." -ForegroundColor Yellow
#start-process "cmd.exe" "/c C:\Patching\createRemoteTask.bat"

Write-Host "$($VMName) successfully deployed, disconnecting from vCenter and exiting." -ForegroundColor Green
Exit-Script
