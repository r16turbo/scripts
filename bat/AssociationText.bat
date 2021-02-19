@echo off
setlocal

rem Text Editor Association
set CMD=\"%%LOCALAPPDATA%%\Programs\EmEditor\EmEditor.exe\" \"%%1\"
reg add "HKCU\Software\Classes\txtfile\shell\open\command" /ve /t REG_EXPAND_SZ /d "%CMD%" /f > nul
reg add "HKCU\Software\Classes\inifile\shell\open\command" /ve /t REG_EXPAND_SZ /d "%CMD%" /f > nul
reg add "HKCU\Software\Classes\batfile\shell\edit\command" /ve /t REG_EXPAND_SZ /d "%CMD%" /f > nul
reg add "HKCU\Software\Classes\regfile\shell\edit\command" /ve /t REG_EXPAND_SZ /d "%CMD%" /f > nul
reg add "HKCU\Software\Classes\SystemFileAssociations\text\shell\open\command" /ve /t REG_EXPAND_SZ /d "%CMD%" /f > nul
reg add "HKCU\Software\Classes\SystemFileAssociations\text\shell\edit\command" /ve /t REG_EXPAND_SZ /d "%CMD%" /f > nul

endlocal
pause
exit /b 0
