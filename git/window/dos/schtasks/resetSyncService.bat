@echo off
net stop "EDoc2.DomainSyncServices"
ping -n 10 127.1>nul
net start "EDoc2.DomainSyncServices"