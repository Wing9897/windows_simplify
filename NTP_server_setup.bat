@echo off
echo ########Checking port 123 firewall ...#######
netsh advfirewall firewall show rule name=win32time > nul 2>&1

if %errorlevel%==0 ( 
	echo Firewall rule already exists.
) else (
	netsh advfirewall firewall add rule name="win32time" dir=in action=allow protocol=UDP localport=123 && echo port 123 firewall rule added successfully. || echo port 123 add fail
)

net start W32Time && echo start service done..... || echo start service error....
sc config w32time start=auto && echo edit service done..... || echo edit service error....

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled /t REG_DWORD /d 1 /f && echo add regedit done.... ||echo add regedit fail......
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v AnnounceFlags /t REG_DWORD /d 5 /f && echo add seconde regedit done.... || echo add regedit fail......

pause

