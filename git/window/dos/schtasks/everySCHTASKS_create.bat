@echo off
REM  每天8点
echo %cd%
schtasks /create /tn "everyday.edoc2" /tr %cd%\resetSyncService.bat /sc daily /st 08:00:00 