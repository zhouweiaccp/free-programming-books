@echo off
@call stop.bat
@sqlcmd -S 192.168.252.20 -Usa -P1234 -i E:\212\resort.sql -o E:\212\resort.out 
@call start.bat