@echo off
echo De computer wordt nu opgeschoond.
echo.

REM Stap 1: Windows Update-service stoppen.
net stop wuauserv >nul
echo Stap 1 voltooid.

REM Stap 2: Tijdelijke bestanden verwijderen.
rmdir /q /s /f "%temp%\*" "%systemroot%\Temp\*" "%systemroot%\Prefetch\*"
echo Stap 2 voltooid.

REM Stap 3: Windows Update-cache verwijderen.
rmdir /q /s "%systemroot%\SoftwareDistribution\Download"
echo Stap 3 voltooid.

REM Stap 4: File Explorer-cache verwijderen.
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f >nul
echo Stap 4 voltooid.

REM Stap 5: Browsercaches verwijderen.
echo Bezig met het verwijderen van browsercaches...

REM Chrome-cache verwijderen
start /wait "" "%LocalAppData%\Google\Chrome\Application\chrome.exe" --user-data-dir="%LocalAppData%\Google\Chrome" --disk-cache-size=1
rmdir /q /s "%LocalAppData%\Google\Chrome\User Data\Default\Cache"

REM Firefox-cache verwijderen
start /wait "" "%ProgramFiles%\Mozilla Firefox\firefox.exe" -P "default" -safe-mode
rmdir /q /s "%AppData%\Mozilla\Firefox\Profiles\*.default\cache"

REM Edge-cache verwijderen
start /wait "" "%LocalAppData%\Microsoft\Edge\Application\msedge.exe" --user-data-dir="%LocalAppData%\Microsoft\Edge" --disk-cache-size=1
rmdir /q /s "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache"

REM Internet Explorer-cache verwijderen
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
echo Stap 5 voltooid.

REM Stap 6: File Explorer herstarten.
taskkill /f /im explorer.exe
start explorer.exe
echo Stap 6 voltooid.

REM Stap 7: Windows Update-service starten.
net start wuauserv
echo Stap 7 voltooid.

echo.
echo De computer is opgeschoond.

REM Vrijgekomen ruimte berekenen
echo.
echo Bezig met het berekenen van de vrijgekomen ruimte...

for /f "usebackq tokens=2 delims=," %%a in (`dir /s "%temp%" ^| findstr "File(s)"`) do set "temp_size=%%a"
for /f "usebackq tokens=2 delims=," %%b in (`dir /s "%systemroot%\Temp\" ^| findstr "File(s)"`) do set "system_temp_size=%%b"
for /f "usebackq tokens=2 delims=," %%c in (`dir /s "%systemroot%\Prefetch\" ^| findstr "File(s)"`) do set "prefetch_size=%%c"
for /f "usebackq tokens=2 delims=," %%d in (`dir /s "%systemroot%\SoftwareDistribution\Download" ^| findstr "File(s)"`) do set "update_cache_size=%%d"
for /f "usebackq tokens=2 delims=," %%e in (`dir /s "%LocalAppData%\Google\Chrome\User Data\Default\Cache" ^| findstr "File(s)"`) do set "chrome_cache_size=%%e"
for /f "usebackq tokens=2 delims=," %%f in (`dir /s "%AppData%\Mozilla\Firefox\Profiles\*.default\cache" ^| findstr "File(s)"`) do set "firefox_cache_size=%%f"
for /f "usebackq tokens=2 delims=," %%g in (`dir /s "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache" ^| findstr "File(s)"`) do set "edge_cache_size=%%g"

set /a "total_size=temp_size + system_temp_size + prefetch_size + update_cache_size + chrome_cache_size + firefox_cache_size + edge_cache_size"
set /a "total_gb=total_size / (1024*1024*1024)"
set /a "total_mb=(total_size / (1024*1024)) %% 1024"

echo.
echo Vrijgekomen ruimte: %total_gb% GB %total_mb% MB.

pause
