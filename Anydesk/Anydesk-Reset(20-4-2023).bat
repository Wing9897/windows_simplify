@echo off
if exist "c:\Program Files (x86)" (set ostype=64) else (set ostype=32)
echo !!!!!!!!!Terminating Anydesk Process.!!!!!!!!!!!!!
::終止進程
::for /f是一個循環命令
::%%A是參數變量,%%A=進程名稱, %%B = PID進程 ID
::>nul是指將執行的結果不顯示
::tasklist 是顯示所有進程
::tasklist /FI "IMAGENAME eq Anydesk.exe" 顯示所有進程名IMAGE NAME等於 Anydesk.exe的進程 
::tasklist /NH 是指從輸出中刪除標題行
::tskill %%B = kill 進程id
::"tokens=1,2 delims= " delims是指什麼值用作拆開,這裹是以空格分開,而tokens就是指取第幾個值,這裹得出以空格分隔的第1和2的值
::由於這裡有2個值,而第一個值的命名是%%A ,而cmd設計上是根據第一個參數變量,順延下一個英文字,也就是下一個是%%B
for /f "tokens=1,2 delims= " %%A in ('tasklist /FI "IMAGENAME eq Anydesk.exe" /NH') do echo %%A=%%B &tskill %%B>nul
for /f "tokens=1,2 delims= " %%A in ('tasklist /FI "IMAGENAME eq Anydesk.exe" /NH') do echo %%A=%%B &tskill %%B>nul
for /f "tokens=1,2 delims= " %%A in ('tasklist /FI "IMAGENAME eq Anydesk.exe" /NH') do echo %%A=%%B &tskill %%B>nul
echo #########Resetting Anydesk##################
c:
cd\
cd C:\ProgramData\AnyDesk\
::如果有文件XXX就刪除
if exist system.conf.backup del /f /q system.conf.backup
if exist service.conf.backup del /f /q service.conf.backup
::重命名文件
rename system.conf system.conf.backup
rename service.conf service.conf.backup
::檢查Anydesk安裝位置
cd\
if %ostype%==32 (set pdir="C:\Program Files\AnyDesk\") else (set pdir="C:\Program Files (x86)\AnyDesk\")
c:
cd\
cd %pdir%
::運作進程
start Anydesk.exe
pause