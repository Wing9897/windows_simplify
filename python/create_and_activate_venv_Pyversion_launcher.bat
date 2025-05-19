@echo off
set "venv_dir=myvenv1"
if exist "%venv_dir%" (
::check 文件是否已存在
    echo "The virtual environment already exists."
) else (
    set /p version="type which version you want:"
    echo "Creating virtual environment..."
	::跳到子程序cmd,完成子程序後返回主線cmd繼續執行主程序
    call :create_venv
	
)

echo "Activating virtual environment..."
start cmd /k "%venv_dir%\Scripts\activate.bat"
::新cmd執行activate.bat啟動虛擬環境
exit /b

:create_venv
py -%version% -m venv myvenv1 
exit /b
::使用了 exit /b 命令來退出子程序，以便繼續執行主程序。
