@echo off
set /p Input1=Type IP Address: 
set /p Input2=Type Subnet: 
netsh interface ipv4 set address Ethernet static %Input1% %Input2%
pause