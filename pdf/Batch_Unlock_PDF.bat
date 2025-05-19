@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

REM 不含雙引號
set QPDF=C:\Program Files\qpdf 12.2.0\bin\qpdf.exe

set /p PDF_DIR=請輸入含PDF檔案的資料夾完整路徑:
set /p USER_PASSWORD=請輸入PDF解鎖密碼:

set OUTPUT_DIR=%PDF_DIR%\output

if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

pushd "%PDF_DIR%" || (
    echo 無法切換到資料夾 %PDF_DIR%
    pause
    exit /b 1
)

for %%F in (*.pdf) do (
    echo 嘗試用密碼解鎖 %%F
    "%QPDF%" --password="%USER_PASSWORD%" --decrypt "%%F" "%OUTPUT_DIR%\%%F" >nul 2>&1
    if !errorlevel! EQU 0 (
        echo [成功] 解鎖檔案 %%F
    ) else (
        echo [失敗] 密碼錯誤或無法解鎖 %%F
    )
)

popd

echo 全部檔案處理完成！
pause