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
set /p Input1=Type REPOSITORY(image name): 
set "Input2=%Input1:/=_%"
docker save -o %Input2%_docker_image.tar %Input1%
echo finish~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pause