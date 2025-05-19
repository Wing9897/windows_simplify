@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

REM qpdf 路徑，**不包含雙引號**
set QPDF=C:\Program Files\qpdf 12.2.0\bin\qpdf.exe

REM 批次檔所在資料夾
set SCRIPT_DIR=%~dp0

REM 密碼檔完整路徑
set PASSWORD_FILE=%SCRIPT_DIR%passwords.txt

REM 確認密碼檔是否存在
if not exist "%PASSWORD_FILE%" (
    echo 找不到密碼檔：%PASSWORD_FILE%
    pause
    exit /b 1
)

REM 請用戶輸入PDF所在資料夾路徑
set /p PDF_DIR=請輸入含PDF檔案的資料夾完整路徑:

REM 輸出資料夾（在輸入資料夾下建立output）
set OUTPUT_DIR=%PDF_DIR%\output

REM 建立輸出資料夾
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

REM 切換到PDF資料夾
pushd "%PDF_DIR%" || (
    echo 無法切換到資料夾 %PDF_DIR%
    pause
    exit /b 1
)

REM 對資料夾內所有PDF檔案進行處理
for %%F in (*.pdf) do (
    set FILE=%%F
    set UNLOCKED=0
    echo 處理檔案：%%F
    REM 逐行讀密碼檔嘗試解鎖
    for /f "usebackq delims=" %%P in ("%PASSWORD_FILE%") do (
        if !UNLOCKED! EQU 0 (
            REM 嘗試解鎖
            "%QPDF%" --password="%%P" --decrypt "%%F" "%OUTPUT_DIR%\%%F" >nul 2>&1
            if !errorlevel! EQU 0 (
                echo [成功] 解鎖檔案 %%F，密碼為：%%P
                set UNLOCKED=1
            )
        )
    )
    if !UNLOCKED! EQU 0 (
        echo [失敗] 所有密碼嘗試完畢，無法解鎖 %%F
    )
)

popd

echo 全部檔案處理完成！
pause