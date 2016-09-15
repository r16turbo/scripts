@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

echo isatap set state disabled
netsh interface isatap set state disabled

echo 6to4 set state disabled
netsh interface 6to4 set state disabled

echo teredo set state disable
netsh interface teredo set state disable

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0
