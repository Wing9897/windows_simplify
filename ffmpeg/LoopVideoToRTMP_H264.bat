ffmpeg -stream_loop -1 -re -i sample.mp4 -c:v libx264 -c:a aac -g 50 -keyint_min 50 -b:v 2000k -r 25 -f flv rtmp://localhost/live/stream
pause