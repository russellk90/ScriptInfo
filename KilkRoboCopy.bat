@ECHO OFF
SETLOCAL

SET _source=\\kilkfs04\E$\Acronis_images
SET _dest=\\kilkfs05\E$\Acronis_images

::SET _source=\\kilkfs04\E$\Apps
::SET _dest=\\kilkfs05\E$\Apps

::SET _source=\\kilkfs04\E$\Bentley_Schema_Files
::SET _dest=\\kilkfs05\E$\Bentley_Schema_Files

::SET _source=\\kilkfs04\"E$\\HP 2800 Drivers"
::SET _dest=\\kilkfs05\"E$\\HP 2800 Drivers"

::SET _source=\\kilkfs04\"E$\\HP 2800 Drivers"
::SET _dest=\\kilkfs05\"E$\\HP 2800 Drivers"

::SET _source=\\kilkfs04\E$\\IT
::SET _dest=\\kilkfs05\E$\\IT

::SET _source=\\kilkfs04\E$\\kilkenny
::SET _dest=\\kilkfs05\E$\\kilkenny

::SET _source=\\kilkfs04\E$\\Mapping
::SET _dest=\\kilkfs05\E$\\Mapping

::SET _source=\\kilkfs04\E$\\mtroot
::SET _dest=\\kilkfs05\E$\\mtroot

::SET _source=\\kilkfs04\E$\\PC_PROGRAMSLIVE1
::SET _dest=\\kilkfs05\E$\\PC_PROGRAMSLIVE1

::SET _source=\\kilkfs04\E$\\users
::SET _dest=\\kilkfs05\E$\\users


SET _what=/COPYALL /ZB /MIR
:: /COPYALL :: COPY ALL file info
:: /ZB :: Use restartable mode; if access denied use Backup mode. 
:: /MIR :: MIRror a directory tree 

SET _options=/R:1 /W:5 /LOG:C:\test\Acronis_images.txt /NFL /NDL

::SET _options=/R:1 /W:5 /LOG:C:\test\Apps.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\Bentley_Schema_Files.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\HP2800Drivers.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\IT.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\kilkenny.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\Mapping.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\mtroot.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\PC_PROGRAMSLIVE1.txt /NFL /NDL
::SET _options=/R:1 /W:5 /LOG:C:\test\users.txt /NFL /NDL


:: /R:n :: number of Retries
:: /W:n :: Wait time between retries
:: /LOG :: Output log file
:: /NFL :: No file logging
:: /NDL :: No dir logging

ROBOCOPY %_source% %_dest% %_what% %_options%


