@echo off
setlocal

rem Check Administrator Permission
net session > nul 2>&1
if errorlevel 1 set ERR_MSG=Permission denied. & goto ERROR

rem System Parameters
set SYSTEM=%ProgramData%\Oracle\Java\javapath

rem Java Commands
set JAVA_CMDS=java javaw jconsole jmc jp2launcher

rem Oracle JavaVM Parameters
set JAVA_ROOT=C:\Program Files\Java
set JAVA_NAME=Java(TM) Platform SE binary
set JAVA_DESC=Java(TM) Platform SE binary

rem Delete Oracle firewall rules
netsh advfirewall firewall delete rule name="%JAVA_NAME%"

rem Setup System Oracle runtime
call :addRuntime "%JAVA_NAME%" "%JAVA_DESC%" "%SYSTEM%" %JAVA_CMDS%

rem Setup all Oracle runtime
for /f %%V in ('dir /a:d /b "%JAVA_ROOT%"') do (
  call :addRuntime "%JAVA_NAME%" "%JAVA_DESC%" "%JAVA_ROOT%\%%V\bin" %JAVA_CMDS%
  call :addRuntime "%JAVA_NAME%" "%JAVA_DESC%" "%JAVA_ROOT%\%%V\jre\bin" %JAVA_CMDS%
)

rem OpenJDK JavaVM Parameters
set JAVA_ROOT=C:\opt\Java
set JAVA_NAME=OpenJDK Platform binary
set JAVA_DESC=OpenJDK Platform binary

rem Delete OpenJDK firewall rules
netsh advfirewall firewall delete rule name="%JAVA_NAME%"

rem Setup all OpenJDK runtime
for /f %%V in ('dir /a:d /b "%JAVA_ROOT%"') do (
  call :addRuntime "%JAVA_NAME%" "%JAVA_DESC%" "%JAVA_ROOT%\%%V\bin" %JAVA_CMDS%
  call :addRuntime "%JAVA_NAME%" "%JAVA_DESC%" "%JAVA_ROOT%\%%V\jre\bin" %JAVA_CMDS%
)

:ERROR
if defined ERR_MSG echo %ERR_MSG%

endlocal
pause
exit /b 0


rem ---------------------------------------------
rem Sub Routine
rem ---------------------------------------------

rem Setup Java runtime
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
