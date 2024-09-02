set executionpolicy bypass –force

$file="C:\Patching\Start Maintenance Mode Task.lnk"
$desktop="C:\Users\Public\Desktop"

   if(Test-Path $desktop){
      Copy-Item $file -Destination $desktop -Verbose
    }
    
read-host 'press enter to exit'