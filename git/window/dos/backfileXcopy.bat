rem ���ݵ�ǰ�ļ� xcopy
set DaysAgo=1
set Today=%date:~0,4%%date:~5,2%%date:~8,2%
set /a PassDays=%Today%-1
echo %cd%\%PassDays%
mkdir %cd%\%Today%\%Today%%time:~0,2%%time:~3,2%%time:~6,2%
xcopy  %cd%\test  %cd%\%Today%\%Today%%time:~0,2%%time:~3,2%%time:~6,2% /d:%date:~5,2%-%date:~8,2%-%date:~0,4% /s
pause