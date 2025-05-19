@echo off
setlocal EnableDelayedExpansion

REM 模式選擇
:MODE_SELECTION
echo 1. Train mode
echo 2. Detect mode (single .jpg in local directory)
echo 3. Camera detect mode
echo 4. Batch detect mode (all .jpg in directory)
set /p MODE="Select mode (1-4): "

if "!MODE!"=="1" goto TRAIN
if "!MODE!"=="2" goto DETECT
if "!MODE!"=="3" goto CAMERA
if "!MODE!"=="4" goto BATCH

echo Invalid mode selected. Please select 1, 2, 3, or 4.
goto MODE_SELECTION

REM 通用參數設置
:SET_PARAMETERS
set "MODEL_DEFAULT=yolo11m.pt"
set /p MODEL="Enter model path (default: %MODEL_DEFAULT%): "
if "!MODEL!"=="" set "MODEL=%MODEL_DEFAULT%"

set "IMGSZ_DEFAULT=640"
set /p IMGSZ="Enter image size (default: %IMGSZ_DEFAULT%): "
if "!IMGSZ!"=="" set "IMGSZ=%IMGSZ_DEFAULT%"
goto :EOF

REM 訓練模式
:TRAIN
call :SET_PARAMETERS

set "EPOCHS_DEFAULT=1000"
set /p EPOCHS="Enter number of epochs (default: %EPOCHS_DEFAULT%): "
if "!EPOCHS!"=="" set "EPOCHS=%EPOCHS_DEFAULT%"

set "BATCH_DEFAULT=16"
set /p BATCH="Enter batch size (default: %BATCH_DEFAULT%): "
if "!BATCH!"=="" set "BATCH=%BATCH_DEFAULT%"

REM 自動尋找.yaml資料集
for %%F in (*.yaml) do (
    set "DATA_DEFAULT=%%F"
    goto FOUND_YAML
)
set "DATA_DEFAULT=dataset.yaml"
:FOUND_YAML
set /p DATAPATH="Enter dataset path (default: %DATA_DEFAULT%): "
if "!DATAPATH!"=="" set "DATAPATH=%DATA_DEFAULT%"

echo Running: yolo train model="%MODEL%" data="%DATAPATH%" epochs=%EPOCHS% batch=%BATCH% imgsz=%IMGSZ%
yolo train model="%MODEL%" data="%DATAPATH%" epochs=%EPOCHS% batch=%BATCH% imgsz=%IMGSZ%
goto END

REM 單張圖片檢測
:DETECT
call :SET_PARAMETERS

for %%F in (*.jpg) do (
    set "SOURCE_DEFAULT=%%F"
    goto FOUND_IMG
)
set "SOURCE_DEFAULT=image.jpg"
:FOUND_IMG
set /p SOURCE="Enter source jpg path (default: %SOURCE_DEFAULT%): "
if "!SOURCE!"=="" set "SOURCE=%SOURCE_DEFAULT%"

if not exist "!SOURCE!" (
    echo Source file not found: !SOURCE!
    goto END
)

echo Running: yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%
yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%

REM 檢測完成後顯示圖片
start "" "%SOURCE%"

goto END

REM 攝像頭檢測
:CAMERA
call :SET_PARAMETERS

echo Running: yolo detect mode=predict model="%MODEL%" source=0 imgsz=%IMGSZ%
yolo detect mode=predict model="%MODEL%" source=0 imgsz=%IMGSZ%
goto END

REM 批量圖片檢測
:BATCH
call :SET_PARAMETERS

set "SOURCE_DEFAULT=*.jpg"
set /p SOURCE="Enter source directory or pattern (default: %SOURCE_DEFAULT%): "
if "!SOURCE!"=="" set "SOURCE=%SOURCE_DEFAULT%"

echo Running: yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%
yolo detect mode=predict model="%MODEL%" source="%SOURCE%" imgsz=%IMGSZ%

REM 批量檢測後顯示圖片
for %%F in (%SOURCE%) do (
    start "" "%%F"
)

goto END

:END
pause
exit /b
