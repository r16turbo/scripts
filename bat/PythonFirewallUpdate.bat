@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

rem Python Parameters
set PYTHON_PATH=C:\opt\Python27
set PYTHON_NAME=python
set PYTHON_DESC=Python
set PYTHON_CMDS=python pythonw

rem Virtualenv Parameters
set VENV_ROOT=C:\opt\venv

rem Delete firewall rules
netsh advfirewall firewall delete rule name="%PYTHON_NAME%"

rem Setup Python runtime
call :addRuntime "%PYTHON_NAME%" "%PYTHON_DESC%" "%PYTHON_PATH%" %PYTHON_CMDS%

rem Setup all Virtualenv runtime
for /f %%V in ('dir /a:d /b "%JAVA_ROOT%"') do (
  call :addRuntime "%PYTHON_NAME%" "%PYTHON_DESC%" "%VENV_ROOT%\%%V\Scripts" %PYTHON_CMDS%
)

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0


rem ---------------------------------------------
rem Sub Routine
rem ---------------------------------------------

rem Setup Python runtime
rem   addRuntime name description path program...
:addRuntime
  if not exist "%~3" exit /b 1
  if not "%4" == "" (
    call :addFirewall "%~1" "%~2" "%~3\%~4.exe"
    shift /4
    goto addRuntime
  )
exit /b 0

rem Setup firewall rules
rem   addFirewall name description program
:addFirewall
  if not exist "%~3" exit /b 1
  netsh advfirewall firewall add rule name="%~1" description="%~2" dir=in action=allow program="%~3"
exit /b 0
