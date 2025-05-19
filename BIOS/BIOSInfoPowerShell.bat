@Echo off
powershell -NoProfile "Get-WmiObject -Class Win32_BIOS | Format-List *"
Pause