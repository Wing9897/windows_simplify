@echo off 
setlocal EnableDelayedExpansion
::環境變數通常是使用 % 符號來表示的,但在例如for loop中不會動態修改,而setlocal EnableDelayedExpansion可以使用!來表達動態變量

::計算netsh interface show interface數量
set index=0

::第一項是管理狀態,第4項是介面名稱,tokens=3* 即係第4個+所有後續項
(for /f "skip=3 tokens=3* delims= " %%a in ('netsh interface show interface') do (
	set /a index+=1 
        echo card name !index! : %%b 
        set adapter[!index!]=%%b 
))

::顯示index的最終數值
echo There are %index% Ethernet adapters found

set /p choice="selection:"
echo Seclected card is : !adapter[%choice%]!
set /p Input1=Type IP Address: 
set /p Input2=Type Subnet: 
netsh interface ipv4 set address !adapter[%choice%]! static %Input1% %Input2% && echo ############# !adapter[%choice%]! is changed IP now (%Input1%) ###########  || echo ############# !adapter[%choice%]! failed to change ###########

::for /l %%i in (1,1,%index%) do (echo Adapter[%%i]: !adapter[%%i]!)
::上面的for /l格式是>>for /l %%parameter in (start,step,end) do (command)

pause