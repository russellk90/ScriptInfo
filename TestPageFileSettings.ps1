

$colItems = get-wmiobject -class "Win32_PageFileUsage" -namespace "root\CIMV2" -computername localhost 
 
foreach ($objItem in $colItems) { 
      $allocate = $objItem.AllocatedBaseSize
      $current = $objItem.CurrentUsage
} 

write-host ""

write-host "Virtual memory (Page File usage for all drives) info in mb below"
write-host ($allocate - $current)

write-host ""

write-host "The disk volume info can be seen below"

Get-Volume

