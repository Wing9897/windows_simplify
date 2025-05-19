@echo off
echo ########Checking port 123 firewall ...#######
netsh advfirewall firewall show rule name=win32time > nul 2>&1

if %errorlevel%==0 ( 
	echo Firewall rule already exists.
) else (
	netsh advfirewall firewall add rule name="win32time" dir=in action=allow protocol=UDP localport=123 && echo port 123 firewall rule added successfully. || echo port 123 add fail
)


net stop w32time && echo stop service done..... || echo stop service error....
w32tm /unregister
w32tm /register
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled /t REG_DWORD /d 1 /f && echo add regedit done.... ||echo add regedit fail......
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v AnnounceFlags /t REG_DWORD /d 5 /f && echo add seconde regedit done.... || echo add regedit fail......
net start W32Time && echo start service done..... || echo start service error....
sc config w32time start=auto && echo edit service done..... || echo edit service error....

pause

:: > nul是指不顯示任何輸出,實際上> nul是運算符,將標準輸出(stdout)重定向到空值
::而"2>&1"表示將標準錯誤（stderr）重定向到與標準輸出相同的位置,即不顯示任何輸出 
:: "> nul 2>&1"的作用是將命令的輸出和錯誤輸出都重定向到空設備，以避免在命令提示符中顯示任何輸出。
:: 1為標準輸出stdout、2為標準錯誤stderr。
:: %errorlevel%是一個特殊的環境變數,他獲得上一個執行的命令的返回值,如果命令執行成功，返回值為0；如果命令執行失敗返回值通常是非零值,而if %errorlevel%==0 是一組cmd比較語句
