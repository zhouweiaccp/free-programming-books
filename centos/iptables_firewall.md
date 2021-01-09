Centos 7 firewall ：
1、firewalld的基本使用
启动： systemctl start firewalld
关闭： systemctl stop firewalld
查看状态： systemctl status firewalld 
开机禁用  ： systemctl disable firewalld
开机启用  ： systemctl enable firewalld
 
 
2.systemctl是CentOS7的服务管理工具中主要的工具，它融合之前service和chkconfig的功能于一体。
启动一个服务：systemctl start firewalld.service
关闭一个服务：systemctl stop firewalld.service
重启一个服务：systemctl restart firewalld.service
显示一个服务的状态：systemctl status firewalld.service
在开机时启用一个服务：systemctl enable firewalld.service
在开机时禁用一个服务：systemctl disable firewalld.service
查看服务是否开机启动：systemctl is-enabled firewalld.service
查看已启动的服务列表：systemctl list-unit-files|grep enabled
查看启动失败的服务列表：systemctl --failed

3.配置firewalld-cmd
查看版本： firewall-cmd --version
查看帮助： firewall-cmd --help
显示状态： firewall-cmd --state
查看所有打开的端口： firewall-cmd --zone=public --list-ports
更新防火墙规则： firewall-cmd --reload
查看区域信息:  firewall-cmd --get-active-zones
查看指定接口所属区域： firewall-cmd --get-zone-of-interface=eth0
拒绝所有包：firewall-cmd --panic-on
取消拒绝状态： firewall-cmd --panic-off
查看是否拒绝： firewall-cmd --query-panic
 
那怎么开启一个端口呢
添加
firewall-cmd --zone=public --add-port=80/tcp --permanent    （--permanent永久生效，没有此参数重启后失效）
重新载入
firewall-cmd --reload
查看
firewall-cmd --zone= public --query-port=80/tcp
删除
firewall-cmd --zone= public --remove-port=80/tcp --permanent
 
调整默认策略（默认拒绝所有访问，改成允许所有访问）：
firewall-cmd --permanent --zone=public --set-target=ACCEPT
firewall-cmd --reload
对某个IP开放多个端口：
firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="10.159.60.29" port protocol="tcp" port="1:65535" accept"
firewall-cmd --reload
 
Centos 6 iptables：
1、iptables的基本使用
启动： service iptables start
关闭： service iptables stop
查看状态： service iptables status
开机禁用  ： chkconfig iptables off
开机启用  ： chkconfig iptables on
2、开放指定的端口
-A和-I参数分别为添加到规则末尾和规则最前面。

#允许本地回环接口(即运行本机访问本机)
iptables -A INPUT -i lo -j ACCEPT
# 允许已建立的或相关连的通行
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#允许所有本机向外的访问
iptables -P INPUT ACCEPT
iptables -A OUTPUT -j ACCEPT
# 允许访问22端口
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 10.159.1.0/24 --dport 22 -j ACCEPT   
注：-s后可以跟IP段或指定IP地址
#允许访问80端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#允许FTP服务的21和20端口
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 20 -j ACCEPT
#如果有其他端口的话，规则也类似，稍微修改上述语句就行
#允许ping
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
#禁止其他未允许的规则访问
iptables -A INPUT -j REJECT  #（注意：如果22端口未加入允许规则，SSH链接会直接断开。）
iptables -A FORWARD -j REJECT
3、屏蔽IP
#如果只是想屏蔽IP的话 “3、开放指定的端口” 可以直接跳过。
#屏蔽单个IP的命令是
iptables -I INPUT -s 123.45.6.7 -j DROP
#封整个段即从123.0.0.1到123.255.255.254的命令
iptables -I INPUT -s 123.0.0.0/8 -j DROP
#封IP段即从123.45.0.1到123.45.255.254的命令
iptables -I INPUT -s 124.45.0.0/16 -j DROP
#封IP段即从123.45.6.1到123.45.6.254的命令是
iptables -I INPUT -s 123.45.6.0/24 -j DROP
4、查看已添加的iptables的规则
iptables -L -n

N：只显示IP地址和端口号，不将IP解析为域名

删除已添加的iptables的规则
将所有iptables以序号标记显示，执行：

iptables -L -n --line-numbers

比如要删除INPUT里序号为8的规则，执行：

iptables -D INPUT 8

5、也可以直接编辑配置文件，添加iptables防火墙规则：
iptables的配置文件为/ etc / sysconfig / iptables

编辑配置文件：

vi /etc/sysconfig/iptables

文件中的配置规则与通过的iptables命令配置，语法相似：

如，通过iptables的命令配置，允许访问80端口：

iptables -A INPUT -p tcp --dport 80 -j ACCEPT

那么，在文件中配置，只需要去掉句首的iptables，添加如下内容：

-A INPUT -p tcp --dport 80 -j ACCEPT

保存退出。

 

有两种方式添加规则

iptables -A 和iptables -I

iptables -A 添加的规则是添加在最后面。如针对INPUT链增加一条规则，接收从eth0口进入且源地址为192.168.0.0/16网段发往本机的数据。

[root@localhost ~]# iptables -A INPUT -i eth0 -s 192.168.0.0/16 -j ACCEPT

iptables -I 添加的规则默认添加至第一条。

如果要指定插入规则的位置，则使用iptables -I 时指定位置序号即可。

 

删除规则

如果删除指定则，使用iptables -D命令，命令后可接序号。效果请对比上图。

或iptables -D 接详细定义；

如果想把所有规则都清除掉，可使用iptables -F。

 

备份iptabes rules

使用iptables-save命令，如：

[root@localhost ~]# iptables-save > /etc/sysconfig/iptables.save

恢复iptables rules

使用iptables命令，如：

[root@localhost ~]# iptables-restore < /etc/sysconfig/iptables.save

 

iptables 配置保存

以上做的配置修改，在设备重启后，配置将丢失。可使用service iptables save进行保存。

[root@localhost ~]# service iptables save

 

重启iptables的服务使其生效：

service iptables save   添加规则后保存重启生效。

service iptables restart