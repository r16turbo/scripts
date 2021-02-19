@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

rem JSON File Type Association
set KEY=HKCR\.json
reg add "%KEY%" /ve               /t REG_SZ /d "txtfile" /f > nul
reg add "%KEY%" /v "Content Type" /t REG_SZ /d "application/json" /f > nul

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0
