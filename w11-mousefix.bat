@echo off

echo Wijzigingen in het register worden aangebracht. Zorg ervoor dat u dit script als beheerder uitvoert.
echo.

set "RegKey=HKCU\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

echo 1. Navigeer naar het pad HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID
reg import "HKCU\SOFTWARE\CLASSES\CLSID.reg"

echo 2. Een nieuwe sleutel {86ca1aa0-34aa-4e8b-a509-50c905bae2a2} wordt gemaakt.
reg add "%RegKey%" /f >nul

echo 3. Een nieuwe sub-sleutel InprocServer32 wordt gemaakt.
reg add "%RegKey%\InprocServer32" /f >nul

echo 4. De waarde van de sub-sleutel InprocServer32 wordt leeggemaakt.
reg add "%RegKey%\InprocServer32" /ve /d "" /f >nul

echo De wijzigingen zijn aangebracht. Je moet opnieuw aanmelden om de wijzigingen door te voeren.
echo.

pause
