
tracert www.baidu.com
nslookup  www.baidu.com  用于测试或解决DNS服务器问题，该命令用两种模式:(1)非交互式模式；(2)交互式模式
nbtstat -n  命令使用TCP/IP上的NetBIOS显示协议统计和当前TCP/IP连接，使用这个命令你可以得到远程主机的NETBIOS信息，比如用户名、所属的工作组、网卡的MAC地址等

route print  路由信息
route -p add 134.105.0.0 mask 255.255.0.0 134.105.64.1  意思是：所有需要发往134.105.0.0/16地址段的IP数据包，全部由134.105.64.1路径转发。
route delete 10.0.0.0 mask 255.0.0.0 192.168.1.1 则是删除上面添加的路


虚拟IP,地址漂移

https://cloud.tencent.com/developer/article/1398971 Linux路由实践」之实现跨多网段通信【网络路由篇】

ICMP 监测 电力谐波和UPS电源也是列入定期检查的内容  https://wenku.baidu.com/view/29493f7327284b73f242506b.html
IP地址漂移的实现与原理   https://www.bbsmax.com/A/x9J2ZnBZJ6/


## 显示 IP 地址和其他信息
netsh interface ipv4 show config

### Dos命令快速设置ip、网关、dns地址
netsh interface ip set address name="本地连接" source=static 192.168.1.8 255.255.255.0 192.168.1.1 1
netsh interface ip set dns "本地连接" static 114.114.114.114 primary
netsh interface ip add dns "本地连接" 8.8.8.8
##  dns缓存清理
ipconfig/flushdns