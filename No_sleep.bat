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
::修改當前電源方案
::硬碟休眠
powercfg /x -disk-timeout-ac 0
powercfg /x -disk-timeout-dc 0
::螢幕休眠
powercfg /x -monitor-timeout-ac 0
powercfg /x -monitor-timeout-dc 0
::讓電腦休眠(S3) 
Powercfg /x -standby-timeout-ac 0
powercfg /x -standby-timeout-dc 0
::休眠過後進入(S4) 
powercfg /x -hibernate-timeout-ac 0
powercfg /x -hibernate-timeout-dc 0
::更大權限地禁止休眠,例如取消埋可以修改休眠的時間
powercfg /hibernate off
pause