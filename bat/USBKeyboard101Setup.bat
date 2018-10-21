@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

rem http://www.linux-usb.org/usb.ids
rem 0853  Topre Corporation
rem 	0100  HHKB Professional
rem 	0111  REALFORCE87
call :setup "HKLM\SYSTEM\CurrentControlSet\Enum\HID" 0853 0100 0111

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0


rem ---------------------------------------------
rem Sub Routine
rem ---------------------------------------------

rem Setup HID Keyboard 101 Layout
rem   setup HID_KEY VID PID...
:setup
  if not "%3" == "" (
    echo Search: "%~1\VID_%~2&PID_%~3"
    for /f %%K in ('reg query "%~1\VID_%~2&PID_%~3"') do (
      echo Config: "%%K"
      reg delete "%%K\Device Parameters" /va /f > nul
      reg add "%%K\Device Parameters" /v KeyboardSubtypeOverride /t REG_DWORD /d 0 /f > nul
      reg add "%%K\Device Parameters" /v KeyboardTypeOverride    /t REG_DWORD /d 4 /f > nul
    )
    shift /3
    goto setup
  )
exit /b 0
