@echo off
setlocal EnableDelayedExpansion

echo === Hardware Information ===
echo.

:: 1. Get Machine Name (Hostname)
echo Machine Name:
hostname
echo.

:: 2. Get MAC Address (specifically for Bluetooth Device)
echo MAC Address (Bluetooth Device):
wmic nic where "Name='Bluetooth Device (Personal Area Network)'" get MACAddress
echo.

:: 3. Get CPU ID
echo CPU ID:
wmic cpu get ProcessorId
echo.

:: 4. Get Disk Serial Number
echo Disk Serial Number:
wmic diskdrive where "Index=0" get SerialNumber
echo.

:: 5. Get Motherboard Serial Number
echo Motherboard Serial Number:
wmic baseboard get SerialNumber
echo.

:: 6. Get BIOS UUID
echo BIOS UUID:
wmic csproduct get UUID
echo.

echo === End of Hardware Information ===
pause