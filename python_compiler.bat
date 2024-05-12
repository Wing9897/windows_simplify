@echo off
set /p pypath="The python source code path:"
pyinstaller -F %pypath%
echo "finish"
pause

::others pyinstaller parm
:: --icon=iconpath.ico
:: --name=your_app_name
:: -w 使用視窗，無控制台