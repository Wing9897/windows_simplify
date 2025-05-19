@echo off
:: 設置字碼頁為 UTF-8
chcp 65001 >nul

:: 顯示啟動訊息
echo 正在啟用 Windows SMB Server...
echo.

:: 需要管理員權限
NET SESSION >nul 2>&1
if %errorLevel% NEQ 0 (
    echo 請以管理員權限執行此腳本！
    echo 右鍵點擊此檔案，選擇「以管理員身份執行」
    pause
    exit /b
)

:: 獲取電腦名稱
for /f "tokens=*" %%i in ('hostname') do set COMPUTERNAME=%%i

:: 顯示所有有效 IPv4 位址並儲存第一個 IP
echo 本機的所有有效 IPv4 位址如下：
set "FIRST_IP="
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4" ^| findstr /v "169.254"') do (
    if not defined FIRST_IP set "FIRST_IP=%%i"
    echo %%i
)
:: 移除 FIRST_IP 前後的空格
for /f "tokens=* delims= " %%a in ("%FIRST_IP%") do set "FIRST_IP=%%a"

:: 啟用 SMB 2.0 和更高版本
echo 確保 SMB 2.0 以上版本已啟用...
sc config lanmanserver start= auto
sc start lanmanserver

:: 設定防火牆規則
echo 設定防火牆規則...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
netsh advfirewall firewall add rule name="SMB-In" dir=in action=allow protocol=TCP localport=445

:: 創建專屬 SMB 使用者帳戶
echo.
echo 正在創建專屬 SMB 使用者帳戶...
net user smbuser password /add
net user smbuser /expires:never
echo SMB 專屬帳戶已創建！使用者名稱：smbuser 密碼：password

:: 創建並設定共享資料夾
echo.
echo 正在創建並設定共享資料夾 C:\SMBShare...
mkdir C:\SMBShare 2>nul
icacls "C:\SMBShare" /grant "smbuser:(OI)(CI)F" /T
net share SMBShare=C:\SMBShare /grant:smbuser,FULL
echo 共享資料夾 C:\SMBShare 已創建並設定完成！

:: 檢查 SMB 服務狀態
echo.
echo 檢查 SMB 服務狀態...
sc query lanmanserver | find "RUNNING"
if %errorLevel% EQU 0 (
    echo SMB Server 正在運行
) else (
    echo 警告：SMB Server 可能未正常啟動
)

:: 顯示存取說明
echo.
echo ==================================================
echo SMB Server 已啟用！以下是如何存取的說明：
echo.
echo 方法 1：在檔案總管存取
echo  - 在位址列輸入：\\%FIRST_IP%\SMBShare
echo  - 按 Enter，輸入使用者名稱：smbuser 密碼：password
echo.
echo 方法 2：連線網路磁碟機
echo  - 右鍵「此電腦」→ 連線網路磁碟機
echo  - 輸入：\\%FIRST_IP%\SMBShare
echo  - 使用者名稱：smbuser 密碼：password
echo.
echo 方法 3：使用 CMD
echo  - net use X: \\%FIRST_IP%\SMBShare /user:smbuser password
echo.
echo 注意事項：
echo 1. 共享資料夾位於 C:\SMBShare
echo 2. 可能需要重啟電腦使變更生效
echo 3. 確保網路探索和檔案共享已開啟
echo ==================================================

pause