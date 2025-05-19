@echo off
set /p user_input=請確認是否繼續執行(yes/no):
if /i "%user_input%"=="yes" (
  echo 開始執行下一步操作
  bcdboot c:\windows /s d: /f UEFI /l zh-hk && echo build finish || echo build failed
) else (
  echo 用戶取消了操作
  pause
)

::bcdboot是用於配置引導文件的命令行工具的名稱
::c:\windows是指定作為源的 Windows 目錄的位置，將從該目錄中復制啟動環境文件。
::/s把引導文件安裝在那個分區上
::/l zh-hk是啟動windows時的語言而已,使用不正確的語言只會在啟動時出現,不影響載入後的系統
::/f是指定的firmware , 有uefi , bios , all
::bcdboot C:\Windows /l zh-cn是BIOS+MBR常用,
::bcdboot C:\Windows  /s d: /f uefi /l zh-cn是UEFI+GPT常用