@echo off

set /p choice=Do you want to cipher clean up HardDisk?(Y/N): 

if /i "%choice%"=="Y" (
    echo clean up HardDisk
    cipher /w:D:\Private
) else (
    echo cancel
)

pause