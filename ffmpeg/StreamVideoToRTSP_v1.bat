@echo off
set /p location="video path:"
ffmpeg -re -stream_loop -1 -i %location% -c copy -f rtsp rtsp://127.0.0.1:554/test