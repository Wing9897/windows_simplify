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

set subnet[1]=255.255.255.0
set subnet[2]=255.255.0.0
set subnet[3]=255.0.0.0
set /p Input2=Select the subnet(type:[1]=/24,[2]=/16,[3]=/8) :
set Input3=!subnet[%Input2%]!
echo "your subnet -->!subnet[%Input2%]!"
set /p Input4=type gateway:

netsh interface ipv4 set address "!adapter[%choice%]:~0,-1!" static %Input1% %Input3% %Input4% && echo ############# !adapter[%choice%]! is changed IP now (%Input1%) ###########  || echo ############# !adapter[%choice%]! failed to change ###########

::for /l %%i in (1,1,%index%) do (echo Adapter[%%i]: !adapter[%%i]!)
::上面的for /l格式是>>for /l %%parameter in (start,step,end) do (command)

pause