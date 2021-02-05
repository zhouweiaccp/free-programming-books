


## powershell命令快速设置ip、网关、dns地址
1. 导入模块
Import-Module NetTCPIP
Import-Module DnsClient
2. 设置IP地址
New-NetIPAddress -InterfaceIndex 8 -IpAddress 192.168.1.2 -PrefixLength 24 -DefalutGateway 192.168.1.1
InterfaceIndex 可以用”Get-NetIPConfiguration”获得。-IpAddress 后面的内容是设置的IP地址， PrefixLength指子网掩码的长度，DefaultGateway指默认网关。
3. 设置DNS服务器地址
Set-DNSClientServerAddress -InterfaceIndex 8 -ServerAddress ("192.168.1.3","192.168.1.4")
4. Get-NetIPAddress

