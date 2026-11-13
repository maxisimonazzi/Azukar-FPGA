@echo off
:: Lanzador con UAC. Deja la PC como estaba antes de instalar_driver.bat.
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Pidiendo permisos de Administrador...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs -Wait"
    exit /b
)

title Desinstalador de driver WinUSB - Canal A
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0desinstalar.ps1"
echo.
pause
