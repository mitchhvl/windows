@echo off
echo De computer wordt nu opgeschoond.
echo.

REM Stap 1: Windows Update-service stoppen.
net stop wuauserv >nul

REM Stap 2: Tijdelijke bestanden verwijderen.
rmdir /q /s /f "%temp%\*" "%systemroot%\Temp\*" "%systemroot%\Prefetch\*"

REM Stap 3: Windows Update-cache verwijderen.
rmdir /q /s "%systemroot%\SoftwareDistribution\Download"

REM Stap 4: File Explorer-cache verwijderen.
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f >nul

REM Stap 5: File Explorer herstarten.
taskkill /f /im explorer.exe
start explorer.exe

REM Stap 6: Windows Update-service starten.
net start wuauserv

echo De computer is opgeschoond.
echo.

pause
