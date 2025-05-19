@echo off
setlocal EnableDelayedExpansion

set /p exepath="The exe program path:"
set /p serivce_name="Name your service:"
nssm install %serivce_name% %exepath%