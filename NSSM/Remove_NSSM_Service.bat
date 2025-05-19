@echo off
setlocal EnableDelayedExpansion
set /p serivce_name="Name your service:"
nssm remove %serivce_name%