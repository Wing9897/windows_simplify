@echo off
chcp 65001
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Administrator PRIVILEGES Detected! 
) ELSE (
    ECHO please use System Admin to run!!!
	pause
	exit
)
@echo ****************1.enable Windows Update Service ...******************
net start bits
net start wuauserv
net start cryptsvc
sc config "wuauserv" start=demand
sc config "bits" start=demand
sc config "cryptsvc" start=demand
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v AUOptions /f
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoWindowsUpdate /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetDisableUXWUAccess /f
@echo *****************END******************
pause