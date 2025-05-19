::雙冒號是注釋,@echo off是指之後的命令不會重覆顯示，即不回顯，也不會顯示當前路徑位置
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
@echo ****************1.Stopping the Windows Update Service ...******************
::啟動服務
net start bits
net start wuauserv
net start cryptsvc 
@echo ****************2.Disabling the Windows Update Service*******************
::設定服務開機是否啟動
sc config "wuauserv" start=auto
sc config "bits" start=auto
sc config "cryptsvc" start=auto
@echo ****************3.Editing the regedit table to disable windows update*******************
::禁止自動更新
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 0 /f
::禁止自動更新
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v AUOptions /t REG_DWORD /d 0 /f
::禁止WindowsUpdate
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoWindowsUpdate /t REG_DWORD /d 0 /f
::關閉更新按鈕
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetDisableUXWUAccess /t REG_DWORD /d 0 /f
@echo *****************END******************
::暫定
pause