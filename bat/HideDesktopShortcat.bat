@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

rem Set Hide attribute for Desktop Shortcuts
attrib +H %PUBLIC%\Desktop\*.lnk

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0
