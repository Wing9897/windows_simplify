@echo off
setlocal

:: Prompt the user to enter the video file name
set /p videoFile="Please enter the video file name (including extension, e.g., .mp4): "

:: Check if the video file name is provided
if "%videoFile%"=="" (
    echo No video file name provided. Exiting program.
    exit /b
)

:: Prompt the user to enter the frames per second (FPS)
set /p fps="Please enter the FPS (enter 0 to extract all frames): "

:: Construct the FFmpeg command
set "outputPattern=output_%%04d.png"

if "%fps%"=="0" (
    set "ffmpegCommand=ffmpeg -i "%videoFile%" "%outputPattern%""
) else (
    set "ffmpegCommand=ffmpeg -i "%videoFile%" -vf "fps=%fps%" "%outputPattern%""
)

:: Execute the FFmpeg command
echo Running command: %ffmpegCommand%
cmd /c %ffmpegCommand%

echo Done!
pause
endlocal