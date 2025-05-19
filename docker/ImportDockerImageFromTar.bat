@echo off

:: 執行第一個命令
docker images
:: 如果上一個命令失敗，則退出批次檔
if errorlevel 1 (
    color 4
    echo *******Error********
    pause
    exit /b 1
)
color 02
set /p Input1=Enter the path to the image tar:
docker load -i %Input1%
echo finish~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pause