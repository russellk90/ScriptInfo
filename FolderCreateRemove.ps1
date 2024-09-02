# get all files and folders from parent directory

#$allfiles = get-childitem "c:\folder" -Recurse
$allfiles = get-childitem "B:\Downloads\test" -Recurse


# find the program.exe and file.pdf in question
$toRemove = 
$allfiles | 
#where {$_.name -eq 'program.exe' -or $_.name -eq 'file.pdf'}
where {$_.name -eq 'kevtest.txt' -or $_.name -eq 'kevtest1.txt'}

$toADD = 
$allfiles | 
#where {$_.name -eq 'program.exe' -or $_.name -eq 'file.pdf'}
where {$_.name -eq 'kevtest.txt' -or $_.name -eq 'kevtest1.txt'}


# remove the directory and it's contents where they were found in
foreach($file in $toRemove){
    remove-item $file.DirectoryName -Recurse -Force -verbose -WhatIf
}

foreach($file in $toADD){
    Add-item $file.DirectoryName -Recurse -Force -verbose -WhatIf
}