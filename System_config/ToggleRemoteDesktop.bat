@echo off
for /f "tokens=2 delims==" %%A in ('wmic path win32_OperatingSystem get OSLanguage /Value') do set oslanguage=%%A
REM if %oslanguage%==1028 (start cmd /k "mode con:cols=80 lines=30 &color 9f && echo switching the UTF8 console ...  && timeout /t 3 >nul && exit")
chcp 65001
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections > nul 2>&1
if errorlevel 1 goto :on_remote
for /f "tokens=3" %%b in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections') do set value=%%b
if %value%==0x0 (
	netsh advfirewall firewall set rule group="Remote Desktop" new enable=No  && echo #######Turned off Remote Desktop########
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
	pause
	exit
)
:on_remote
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes && echo #######Turned on Remote Desktop########
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
pause

REM 由於在防火牆群組名是使用中文,因此如果系統是繁中1028,就要使用chcp 65001切換控制台的編碼頁 , 65001 對應的是 UTF-8 編碼
REM 判斷remote desktop注冊表的fDenyTSConnections REG_DWORD值如果為為0則改為1,相反則為0,以開關remote desktop
REM 根據OS語言如果為中文則以中文方法改防火牆,相反就是以英文

