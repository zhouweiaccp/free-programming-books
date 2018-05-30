@echo off

echo %cd%
schtasks /delete /tn "everyday.edoc2"