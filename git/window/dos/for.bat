@echo off  
setlocal enabledelayedexpansion  
set /a v=0  
for %%i in (E:\Projectt\2017\github\free-programming-books\*.*) do (  
echo %%i  
echo -------!v!------  
set /a v+=1  
)  
pause 