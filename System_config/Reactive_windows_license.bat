@echo off
echo 1. Retrieving original product key from motherboard...
for /f "skip=1 tokens=*" %%i in ('wmic path softwarelicensingservice get OA3xOriginalProductKey') do (
    set "originalKey=%%i"
    goto :continue
)
:continue

echo 2. Deleting existing license...
slmgr /upk
echo.

echo 3. Enter your Windows license key (or press Enter to use the original product key from the motherboard):
set /p "newKey=%originalKey%"
if "%newKey%"=="" set "newKey=%originalKey%"
echo.

echo 4. Installing new license...
slmgr /ipk %newKey%
echo.

echo 5. Checking license data...
slmgr /dlv
pause