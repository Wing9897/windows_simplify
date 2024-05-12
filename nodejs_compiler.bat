@echo off
setlocal EnableDelayedExpansion
set /p jspath="The javascript source code path:"
set platform[1]=windows
set platform[2]=linux
set /p Input2=Select the platform(type:[1]=windows,[2]=linux) :
set Input3=!platform[%Input2%]!
pkg -t %Input3% %jspath%
echo "finish"
pause

::others pyinstaller parm
:: --icon=iconpath.ico
:: --name=your_app_name
:: -w 使用視窗，無控制台