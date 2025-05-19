@echo off
setlocal enabledelayedexpansion

:askport
set /p choice="Enter the port number to check: "

netstat -ano | findstr ":%choice%" > nul
if %errorlevel% equ 0 (
    echo #Port %choice% is currently in use!
) else (
    echo #Port %choice% is available.
)

echo.
set /p continue="Do you want to check another port? (y/n) "
if /i "%continue%" equ "y" goto askport
pause