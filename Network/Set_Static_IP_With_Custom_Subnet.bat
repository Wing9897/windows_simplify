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
echo #####There are %index% Ethernet adapters found#####

set /p choice="Network card selection:"
echo Seclected card is : !adapter[%choice%]!
set /p Input1=Type IP Address:

set subnet[1]=128.0.0.0
set subnet[2]=192.0.0.0
set subnet[3]=224.0.0.0
set subnet[4]=240.0.0.0
set subnet[5]=248.0.0.0
set subnet[6]=252.0.0.0
set subnet[7]=254.0.0.0
set subnet[8]=255.0.0.0

set subnet[9]=255.128.0.0
set subnet[10]=255.192.0.0
set subnet[11]=255.224.0.0
set subnet[12]=255.240.0.0
set subnet[13]=255.248.0.0
set subnet[14]=255.252.0.0
set subnet[15]=255.254.0.0
set subnet[16]=255.255.0.0

set subnet[17]=255.255.128.0
set subnet[18]=255.255.192.0
set subnet[19]=255.255.224.0
set subnet[20]=255.255.240.0
set subnet[21]=255.255.248.0
set subnet[22]=255.255.252.0
set subnet[23]=255.255.254.0
set subnet[24]=255.255.255.0

set subnet[25]=255.255.255.128
set subnet[26]=255.255.255.192
set subnet[27]=255.255.255.224
set subnet[28]=255.255.255.240
set subnet[29]=255.255.255.248
set subnet[30]=255.255.255.252
set subnet[31]=255.255.255.254
set subnet[32]=255.255.255.255





set /p Input2=Select the subnet(example:type 24 = /24 = 255.255.255.0) :
set Input3=!subnet[%Input2%]!
echo The selected subnet is : !subnet[%Input2%]!

netsh interface ipv4 set address !adapter[%choice%]! static %Input1% %Input3% && echo ############# !adapter[%choice%]! is changed IP now (%Input1%) ###########  || echo ############# !adapter[%choice%]! failed to change ###########

::for /l %%i in (1,1,%index%) do (echo Adapter[%%i]: !adapter[%%i]!)
::上面的for /l格式是>>for /l %%parameter in (start,step,end) do (command)

pause