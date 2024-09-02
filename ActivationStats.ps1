#$ActivationStatus = get-ciminstance softwarelicensingproduct -filter "name like 'windows%' | where-object {$_.partialproductkey} | select-object licensestatus"
#$licenseresult = switch ($ActivationStatus.licensestatus) {
#0 {"unlicensed"}
#1 {"licensed"}
#2 {"00BGrace"}
#3 {"00TGrace"}
#4 {"NonGenuineGrace"}
#5 {"Not Activated"}
#6 {"ExtendedGrace"}
#default {"unknown"}
#}
#$licenseresult


IF ((get-ciminstance softwarelicensingproduct -filter "NAME LIKE 'windows%'" | WHERE { $\_.partialproductkey } | select -EXPANDPROPERTYLICENSESTATUS) -EQ 1) {Write-Host WINDOWS IS ACTIVEATED} ELSE {WINDOWS IS NOT ACTIVATED !!!}

