@echo off
setlocal EnableDelayedExpansion
set /p ffmpegrootfile="where is your root file:"
cls

for /r "%ffmpegrootfile%" %%G in (ffmpeg.exe) do (
	if exist %%G (
	    echo . 
		echo ************Found ffmpeg.exe at %%G ***************
		set /p video="Input your video:"
		cls
		%%G -re -i !video! -vcodec libx264 -acodec aac -f flv "rtmp://127.0.0.1:11935/hls/123_0"
		pause
		exit
	)
	echo|set /p="."
)
echo . 
echo ffmpeg.exe not found.
pause




REM FFmpeg -re以實時速度讀取輸入文件 , 使用-vcodec libx264指定用作輸出的H.264 編碼器 , -acodec acc指定用作輸出的音頻編碼器 , -f flv指定輸出格式為flv是一種常用於直播的Flash 視頻格式。 , 最後rtmp:// 是指輸出的目的地為rtmp服務器IP, port , url路徑
REM 使用 for /r 命令在 D:\ 目錄下遞歸搜索名為 ffmpeg.exe 的文件。/r 參數表示要遞歸搜索
REM 如果找到後會以FFMPEG變量儲存路徑,%%~dpG 是一個擴展的變量引用，它會將 %%G 變量（即找到的文件的路徑）中的驅動器號（d），路徑（p）和文件名（G）提取出來。
