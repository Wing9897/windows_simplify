@echo off
setlocal EnableDelayedExpansion

for /f "tokens=1,2 delims=:" %%a in ('ipconfig /all ^| findstr /C:"DHCP Server"') do (
  set "adapter=%%a"
  set "dhcp=%%b"
  set "adapter=!adapter:~0,-1!"
  set "dhcp=!dhcp:~1!"
  echo !adapter!: !dhcp!
)

pause