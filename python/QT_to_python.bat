@echo off
echo 此功能需求pyuic5, 請使用pip install pyuic5
set /p Input1=ui_file_location:
pyuic5 -x %Input1% -o qt_test.py
pause