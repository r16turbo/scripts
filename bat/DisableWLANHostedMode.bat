@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

echo wlan set hostednetwork mode=disallow
netsh wlan set hostednetwork mode=disallow

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0
