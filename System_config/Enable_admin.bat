@echo off
::以下是檢查amdin權限
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Administrator PRIVILEGES Detected! 
) ELSE (
    ECHO please use System Admin to run!!!
	pause
	exit
)
::enable administrator
net user administrator /active:yes
::set password
net user administrator "admin1234"
pause