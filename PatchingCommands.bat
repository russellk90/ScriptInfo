net stop wuauserv 
reg Delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v SusClientId /f  
reg Delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate /v SusClientIDValidation /f 
net start wuauserv 
wuauclt.exe /resetauthorization /detectnow 
pause
wuauclt.exe /detectnow
wuauclt.exe /reportnow
wuauclt.exe /updatenow
netsh winhttp import proxy source=ie
powershell -Command "& {set-executionpolicy remotesigned}"
