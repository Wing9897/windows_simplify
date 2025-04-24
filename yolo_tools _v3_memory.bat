@echo off
chcp 65001
setlocal EnableDelayedExpansion

REM --- 設定參數檔案 ---
set "INPUT_FILE=last_input.txt"

REM --- 載入上次參數或建立預設值 ---
:LOAD_LAST_INPUT
if exist "%INPUT_FILE%" (
    for /f "tokens=1,2 delims==" %%A in (%INPUT_FILE%) do (
        set "%%A=%%B"
    )
) else (
    REM 檔案不存在時使用預設值
    set "MODEL=yolo11m.pt"
    set "IMGSZ=640"
    set "EPOCHS=1000"
    set "BATCH=16"
    set "DATAPATH=dataset.yaml"
    REM 建立參數檔案
    call :SAVE_INPUT
)
goto :MODE_SELECTION

REM --- 儲存參數到檔案 ---
:SAVE_INPUT
(
echo MODEL=%MODEL%
echo IMGSZ=%IMGSZ%
echo EPOCHS=%EPOCHS%
echo BATCH=%BATCH%
echo DATAPATH=%DATAPATH%
) > "%INPUT_FILE%"
goto :EOF

REM --- 模式選擇 ---
:MODE_SELECTION
echo.
echo 1. Train mode
echo 2. Detect mode (Single .jpg)
echo 3. Camera detect mode (Camera)
echo 4. Batch detect mode (ALL .jpg)
set /p MODE="Select mode (1-4): "

if "!MODE!"=="1" goto TRAIN
if "!MODE!"=="2" goto DETECT
if "!MODE!"=="3" goto CAMERA
if "!MODE!"=="4" goto BATCH

echo 請選擇 1、2、3 或 4.
goto MODE_SELECTION

REM --- 訓練模式參數 ---
:TRAIN_PARAMS
echo.
set /p MODEL="Enter model path (default: %MODEL%): "
if "!MODEL!"=="" set "MODEL=%MODEL%"
set /p DATAPATH="Enter dataset path (default: %DATAPATH%): "
if "!DATAPATH!"=="" set "DATAPATH=%DATAPATH%"
set /p EPOCHS="Enter number of epochs (default: %EPOCHS%): "
if "!EPOCHS!"=="" set "EPOCHS=%EPOCHS%"
set /p BATCH="Enter batch size (default: %BATCH%): "
if "!BATCH!"=="" set "BATCH=%BATCH%"
set /p IMGSZ="Enter image size (default: %IMGSZ%): "
if "!IMGSZ!"=="" set "IMGSZ=%IMGSZ%"
call :SAVE_INPUT
goto :EOF

REM --- 檢測模式參數 ---
:DETECT_PARAMS
echo.
set /p MODEL="Enter model path (default: %MODEL%): "
if "!MODEL!"=="" set "MODEL=%MODEL%"
set /p IMGSZ="Enter image size (default: %IMGSZ%): "
if "!IMGSZ!"=="" set "IMGSZ=%IMGSZ%"
call :SAVE_INPUT
goto :EOF

REM --- 訓練模式 ---
:TRAIN
call :TRAIN_PARAMS
echo.
echo Running: yolo train model="%MODEL%" data="%DATAPATH%" epochs=%EPOCHS% batch=%BATCH% imgsz=%IMGSZ%
yolo train model="%MODEL%" data="%DATAPATH%" epochs=%EPOCHS% batch=%BATCH% imgsz=%IMGSZ%
goto END

REM --- 單張圖片檢測 ---
:DETECT
call :DETECT_PARAMS
echo.
set /p SOURCE="Enter source jpg path (default: image.jpg): "
if "!SOURCE!"=="" set "SOURCE=image.jpg"
if not exist "!SOURCE!" (
    echo 找不到來源檔案: !SOURCE!
    goto END
)
echo.
echo Running: yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%
yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%
start "" "%SOURCE%"
goto END

REM --- 攝像頭檢測 ---
:CAMERA
call :DETECT_PARAMS
echo.
echo Running: yolo detect mode=predict model="%MODEL%" source=0 imgsz=%IMGSZ%
yolo detect mode=predict model="%MODEL%" source=0 imgsz=%IMGSZ%
goto END

REM --- 批量圖片檢測 ---
:BATCH
call :DETECT_PARAMS
echo.
set /p SOURCE="Enter source directory or pattern (default: *.jpg): "
if "!SOURCE!"=="" set "SOURCE=*.jpg"
echo.
echo Running: yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%
yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%

REM 動態查找最新的檢測結果文件夾
set "OUTPUT_DIR="
for /f "delims=" %%D in ('dir "runs\detect" /ad /b /o-d') do (
    set "OUTPUT_DIR=runs\detect\%%D"
    goto :FOUND_DIR
)

:FOUND_DIR
if defined OUTPUT_DIR (
    echo.
    echo Detection results saved in: %OUTPUT_DIR%
    echo Opening all JPG files in the detection result folder...
    for %%F in ("%OUTPUT_DIR%\*.jpg") do (
        echo Found: %%F
        start "" "%%F"
    )
) else (
    echo Warning: No detection output directory found. Check if the detection ran successfully.
)

goto END

:END
pause
exit /b