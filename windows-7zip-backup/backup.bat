REM alm@ipnordic.dk
REM Make dir C:\logs
REM Open cmd and type gpedit.msc. Go to User Configuration > Windows Settings > Scripts, Logoff > Properties and show Files. Add the script in that location.
@echo off
setlocal
REM :PROMPT
REM SET /P WANT=Do you want to backup? (Y/[N])
REM IF /I "%WANT%" NEQ "Y" GOTO END
set logfile=C:\logs\backup.txt
set server=SERVER_IP
set mount=pushd \\%server%\share$
set unmount=popd
set source="{SOURCE}"
set dest="destination.7z"
set AppExePath="%ProgramFiles(x86)%\7-Zip\7z.exe"
ping %server% -n 1 -w 1000 | find "TTL=" >nul
if errorlevel 1 goto serverdown
%mount%
if errorlevel 1 goto notInstalled-share
if not exist %AppExePath% set AppExePath="%ProgramFiles%\7-Zip\7z.exe"
if not exist %AppExePath% goto notInstalled
echo %date% > %logfile%
echo %time% Backing up %source% to %dest% >> %logfile%
%AppExePath% u -up0q3r2x2y2z1w2 %dest% %source% -mhe -P{PASSWORD}
echo %time% %source% backed up to %dest% is complete! >> %logfile%
%unmount%
goto end
:serverdown
echo %date% > %logfile%
echo %time% Server is unreachable! >> %logfile%
goto end
:notInstalled-share
echo %date% > %logfile%
echo %time% Share location not found or not mounted! >> %logfile%
goto end
:notInstalled
echo %date% > %logfile%
echo %time% Can not find 7-Zip, please install it. >> %logfile%
%unmount%
goto end
:end
REM shutdown -s -t 30
EXIT /B 0


