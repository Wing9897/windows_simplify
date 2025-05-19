@echo off

REM 檢查磁碟並修復錯誤
chkdsk c: /r


REM 對Windows映像進行清理和修復，它會檢查映像中的損壞文件
DISM /Online /Cleanup-Image /RestoreHealth


REM 掃描並修復系統檔案
sfc /scannow