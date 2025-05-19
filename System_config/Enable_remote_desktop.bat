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
@echo ****************2.enable admin....*******************
net user administrator /active:yes
net user administrator "admin12345"
@echo ****************4.turn on Remote Desktop....*******************
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes && echo #######Turned on Remote Desktop########
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
@echo *****************END******************
pause