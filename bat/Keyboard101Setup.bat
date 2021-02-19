@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

set KEY=HKLM\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters
reg add "%KEY%" /v "LayerDriver JPN"            /t REG_SZ /d "kbd101.dll" /f > nul
reg add "%KEY%" /v "OverrideKeyboardIdentifier" /t REG_SZ /d "PCAT_101KEY" /f > nul
reg add "%KEY%" /v "OverrideKeyboardType"       /t REG_DWORD /d 7 /f > nul
reg add "%KEY%" /v "OverrideKeyboardSubtype"    /t REG_DWORD /d 0 /f > nul
reg query "%KEY%"

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0
