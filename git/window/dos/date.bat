@echo off
set DaysAgo=1
set Today=%date:~0,4%%date:~5,2%%date:~8,2%
set /a PassDays=%Today%-1
echo %PassDays%
pause
