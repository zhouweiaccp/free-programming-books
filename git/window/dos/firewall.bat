
#https://github.com/Awesome-Windows/awesome-windows-command-line#firewall
netsh firewall set opmode mode=ENABLE
netsh firewall set opmode mode=DISABLE

* For later versions *

netsh advfirewall set currentprofile state on
netsh advfirewall set  currentprofile state off

netsh advfirewall set domainprofile state on
netsh advfirewall set domainprofile state off

netsh advfirewall set privateprofile state on
netsh advfirewall set privateprofile state off

netsh advfirewall set publicprofile state on
netsh advfirewall set publicprofile state off

netsh advfirewall set  allprofiles state on
netsh advfirewall set  allprofiles state off


rem 打开sshd.exe的防火墙以允许入站SSH连接
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
rem New-NetFirewallRule仅适用于Windows 2012及更高版本的服务器。如果您位于客户端台式机（如Windows 10）或Windows 2008 R2及更低版本上，请尝试
netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22
net start sshd