echo off
set tt=%date:~0,4%%date:~5,2%%date:~8,2%
echo %tt%
set tt1=%tt%all
echo %tt1%
 %windir%\system32\inetsrv\appcmd restore  backup %tt1%