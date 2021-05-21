sshd修改端口
vim /etc/ssh/sshd_config
 Port 22  改成  Port 2202
 /etc/init.d/ssh restart

.改变权限
 $ chmod a+w /etc/sudoers 
$ vi /etc/sudoers
# 然后添加 username 到 root 下，内容见下图
$ chmod a-w /etc/sudoers

创建用户  useradd -r -m -s /bin/bash root1 
设置密码  passwd root1
赋予用户root权限  vim /etc/sudoers
添加　root1 ALL=(ALL:ALL) ALL NOPASSWD: ALL

删除用户 userdel -r spark 

xshell关闭后保持程序运行 nohup 你的指令 &

更新ubuntu软件源
sudo apt-get update
sudo apt-get install -y python-software-properties software-properties-common
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update

dos2unix
（1）安装tofrodos
sudo apt-get install tofrodos 
实际上它安装了两个工具：todos（相当于unix2dos），和fromdos（相当于dos2unix）
安装完即可，现在你已经可以进行文本格式的转换啦。 
比如：

todos Hello.txt (即unix2dos Hello.txt) 
fromdos Hello.txt (即dos2unix Hello.txt)

（2）做一些优化 
由于习惯了unix2dos和dos2unix的命令，可以把上面安装的两个工具链接成unix2dos 和dos2unix，或者仅仅是起个别名，并放在启动脚本里。
步骤：
ln -s /usr/bin/todos /usr/bin/unix2dos 
ln -s /usr/bin/fromdos /usr/bin/dos2unix 
或者在 ~/.bashrc里起个别名
vi ~/.bashrc

添加 alias unix2dos=todos alias dos2unix=fromdos

## 常用软件
https://github.com/cjy37/linux-asp.net-installScript
 https://github.com/summerblue/laravel-ubuntu-init/blob/master/16.04/install.sh 
 * [lnmp](https://github.com/licess/lnmp)     自动安装 
* [lamp](https://lamp.sh/install.html) 安装全一些
* [oneinstack lamp](https://github.com/oneinstack/lamp)   更标准一些 This script is written using the shell, in order to quickly deploy LEMP/LAMP/LNMP/LNMPA/LTMP(Linux, Nginx/Tengine/OpenResty, MySQL in a production environment/MariaDB/Percona, PHP, JAVA), applicable to CentOS 6 ~ 7(including redhat), Debian 6 ~ 9, Ubuntu 12 ~ 18, Fedora 27~28 of 32 and 64
* [宝塔Linux面](https://www.bt.cn/download/linux.html) 宝塔Linux面板 6.8 环境
关闭shell后如何保持程序继续运行
nohup npm start &


 添加PATH环境变量(临时)
export PATH=/opt/STM/STLinux-2.3/devkit/sh4/bin:$PATH

永久添加环境变量(影响当前用户)
vim ~/.bashrc
export PATH="/opt/STM/STLinux-2.3/devkit/sh4/bin:$PATH"

5.永久添加环境变量(影响所有用户)
# vim /etc/profile
在文档最后，添加:
export PATH="/opt/STM/STLinux-2.3/devkit/sh4/bin:$PATH"
保存，退出，然后运行：
#source /etc/profile

#显示时区
echo `date +%z`
时间不同步
yum install -y ntp  && ntpdate ntp.aliyun.com

#Linux下查看进程和端口信息
netstat -aon |grep 301
 ps -ef |grep 11753

 #ERROR: The certificate of 
 wget https://bad.com/a.rpm --no-check-certificate
 apt-get install ca-certificates -y



 ## xshell 使用命令上传、下载文件
 rpm -qa |grep lrzsz
 yum install  lrzsz -y
 rz  #上传文件，使用#rz，然后会弹出选择对话框，选择好文件后，点击打开就能上传到当前目录
 sz error_logs #例如要下载当前目录下的error_logs

 ## linux shell 最后一行添加内容
sed '1i 添加的内容' file  #这是在第一行前添加字符串
sed '$i 添加的内容' file  #这是在最后一行行前添加字符串
sed '$a添加的内容' file  #这是在最后一行行后添加字符串
 sed -i '$a\/etc\/install.sh' ho

# 出包dpkg 后面一行加33333
 sed -i '/dpkg/a\3333333333' netocre.sh

 # 在包含小明的行前一行增加一行
 sed '/xiaoming/i\#!/bin/bash' test_sed
 删除文档的第一行
	sed -i '1d' <file>

2、删除文档的最后一行
	sed -i '$d' <file>

## grep -o显示用户
grep -o '^[0-9a-zA-Z_-]\+' /etc/passwd

## Tasksel
sudo apt-get install tasksel
sudo tasksel
https://help.ubuntu.com/community/Tasksel


## 显示ip
 ifconfig |awk '/inet/ && !($2 ~/^127/){print $2}'


## --stdin用法
ssh 10.10.17.2 "echo 'a2p13mvh' | passwd --stdin root"

## 目录大小
du -h --max-depth=0  code/

 ## 安装rpm包
  apt-get install alien
  alien xxxx.rpm
  dpkg -i xxxx.deb 


## Read-only file system的解决办法
mount rw -o remount / 
fsck.ext4 -y /dev/vda

## echo '0' > /proc/sys/net/ipv4/tcp_timestamps
echo '0' > /proc/sys/net/ipv4/tcp_tw_recycle [解Bug之路-记一次调用外网服务概率性失败问题的排查](https://www.cnblogs.com/alchemystar/p/13444964.html)

## dns缓存清理
nscd restart
nscd -i hosts

yum -y install nscd

## perf性能分析工具
apt install -y linux-tools-common

## 防火墙
ufw status


## max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

调整内核参数:

echo "vm.max_map_count=262144" >> /etc/sysctl.conf

echo "fs.file-max=65536" >> /etc/sysctl.conf

echo "* - nofile 65535" >> /etc/security/limits.conf

sysctl -p

##  Screen是一个可以在多个进程之间多路复用一个物理终端的全屏窗口管理器
apt-get install screen
yum install screen
1.1 创建screen会话
可以先执行：screen -S lnmp ，screen就会创建一个名字为lnmp的会话。 VPS侦探 https://www.vpser.net/

1.2 暂时离开，保留screen会话中的任务或程序
当需要临时离开时（会话中的程序不会关闭，仍在运行）可以用快捷键Ctrl+a d(即按住Ctrl，依次再按a,d)

1.3 恢复screen会话
当回来时可以再执行执行：screen -r lnmp
1.4 关闭screen的会话
(base) [root1@iZttsp3neog1bkZ root]$ screen -ls
There is a screen on:
        4481.a  (Detached)
1 Socket in /var/run/screen/S-root1.

(base) [root1@iZttsp3neog1bkZ root]$ screen -X -S 4481 quit
(base) [root1@iZttsp3neog1bkZ root]$ screen -ls
No Sockets found in /var/run/screen/S-root1.


## 关闭SSH其他用户会话连接
pkill -kill -t pts/1

## 查看服务列表代码  
sudo service --status-all

## watch可以帮你监测一个命令的运行结果
watch -n 1 -d "uptime"
watch -n 1 -d 'pstree|grep http'  #每隔一秒高亮显示http链接数的变化情况

##  Redis the tcp backlog
echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local 
chmod +x /etc/rc.d/rc.local 
## getent 
 getent group consul >/dev/null || groupadd -r consul

## watch 定时执行
watch -n 1 date
while true; do date; sleep 1; done
 seq 10 | xargs -i date    seq 生成一个1-10的数组。xargs兴高彩烈的拿着这个数组，准备将数组元素传给date 命令做参数。xargs -i会查找命令字符串中的{}，并用数组元素替换{}。但是xargs一看，WTF！命令里面居然没有占位符。那好吧，就执行10遍命令，让参数随风去吧。


## Cannot assign requested address.
”是由于linux分配的客户端连接端口用尽，无法建立socket连接所致，虽然socket正常关闭，但是端口不是立即释放，而是处于TIME_WAIT状态，默认等待60s后才释放。
可能解决方法1--调低time_wait状态端口等待时间：
1. 调低端口释放后的等待时间，默认为60s，修改为15~30s
sysctl -w net.ipv4.tcp_fin_timeout=30
2. 修改tcp/ip协议配置， 通过配置/proc/sys/net/ipv4/tcp_tw_resue, 默认为0，修改为1，释放TIME_WAIT端口给新连接使用
sysctl -w net.ipv4.tcp_timestamps=1
3. 修改tcp/ip协议配置，快速回收socket资源，默认为0，修改为1
sysctl -w net.ipv4.tcp_tw_recycle=1

可能解决办法2--增加可用端口：
CCH:~ # sysctl -a |grep port_range
net.ipv4.ip_local_port_range = 50000    65000      -----意味着50000~65000端口可用

修改参数：
$ vi /etc/sysctl.conf
net.ipv4.ip_local_port_range = 10000     65000      -----意味着10000~65000端口可用
改完后，执行命令“sysctl -p”使参数生效，不需要reboot。
 


 ## 查看cpu信息及内存大小
1 查看物理CPU的个数
cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l
2、   查看逻辑CPU的个数
cat /proc/cpuinfo |grep "processor"|wc -l
3、  查看CPU是几核
cat /proc/cpuinfo |grep "cores"|uniq
4、  查看CPU的主频
cat /proc/cpuinfo |grep MHz|uniq 
5、cpu是否启用超线程
cat /proc/cpuinfo | grep -e "cpu cores"  -e "siblings" | sort | uniq
siblings 大于 cpu cores，说明启用了超线程
6、查看当前操作系统内核信息
uname –a
7、查看内存大小
cat /proc/meminfo| grep MemTotal
grep MemTotal /proc/meminfo
grep MemTotal /proc/meminfo | cut -f2 -d:
8、查看内存使用情况
free -m
9、查看系统中文件存储使用情况
df –h

## 网络诊断
 tracepath 用于跟踪路由信息
       tracepath -n www.baidu.com
curl/wget 用于探测http服务是否正常
       curl -I www.baidu.com    
       wget -nv  --spider www.baidu.com
nslookup/dig 用于探测域名是否可以解析
       nslookup www.baidu.com
       dig www.baidu.com
ping  用于icmp探测，探测主机是否在线
        ping www.baidu.com

## 安装s3cmd
```sh

yum -y install epel-release
yum -y install s3cmd
cat >> ~/.s3cfg <<eof
[default]
access_key = KMCHVEQCT5OPEP8DDUUL   #替换为自己的ak
secret_key = 881ElYDcgJ3aEPWI6NtmWBEcg2QfhOEdd4OX2WSO  #替换为自己的sk
host_base = 30.30.14.98:12001   #ip替换为自己环境的s3存储地址与端口
host_bucket = 30.30.14.98:12001/%(bucket)   #ip替换为自己环境的s3存储地址与端口
use_https = False
eof

s3cmd ls    #列出当前的存储bucket
s3cmd ls s3://eDoc2    #列出eDoc2的存储桶中的文件
s3cmd get s3://eDoc2/1.txt /opt/1.txt   #保存eDoc2桶中的1.txt至本地的/opt目录
s3cmd put /opt/test.txt s3://eDoc2     #上传本地/opt/test.txt文件至eDoc2存储桶中
s3cmd sync s3://eDoc2/  /opt/backup   #同步eDoc2桶中的所有文件至本地/opt/backup目录中
s3cmd sync /opt/backup  s3://eDoc2/    #同步本地/opt/backup目录中的所有文件至eDoc2桶中

s3cmd get s3://eDoc2/be0486d356044389a05e35655ef7a356 test.xlsx    #eDoc2为存储桶名，改为自己实际使用的，标红处为查询出来的存储路径名，test.xlsx为保存
```
## 查看多核CPU命令
mpstat -P ALL  和  sar -P ALL 

## 端口占用
 ss -tlnp |grep 80
 netstat -anp |grep 80
  ## ifconfig: 未找到命令
   yum install net-tools -y

   ## Linux命令行下抓包工具tcpdump的使用
   yum install -y tcpdump
   - [介绍](./tcpdump.md)



## 网卡绑定
```sh

   #!/bin/bash

IPADDR="192.168.252.242"   #更改为本机的IP地址
NETMASK="255.255.255.0"    #更好为本机IP的子网掩码
GATEWAY="192.168.252.1"    #更改为本机IP的网关
DEVNAME1="ens33"     #需要做绑定的网卡1
DEVNAME2="ens37"     #需要做绑定的网卡2
#DNS1=114.114.114.114  #DNS地址，如需配置，取消注释，并更改为实际dns

NETDIR="/etc/sysconfig/network-scripts"


if [ ! -f "$NETDIR/ifcfg-$DEVNAME1.bak" ]; then
    cp $NETDIR/ifcfg-$DEVNAME1{,.bak}
fi

if [ ! -f "$NETDIR/ifcfg-$DEVNAME2.bak" ]; then
    cp $NETDIR/ifcfg-$DEVNAME2{,.bak}
fi

cat > $NETDIR/ifcfg-bond0 <<EOF
DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
BONDING_OPTS="mode=1 miimon=100"
NM_CONTROLLED=no
IPADDR=$IPADDR
NETMASK=$NETMASK
GATEWAY=$GATEWAY
#DNS1=$DNS1
EOF

if [ x$DNS1 != x ]; then 
sed -i 's/#DNS1/DNS1/' $NETDIR/ifcfg-bond0
fi

cat > $NETDIR/ifcfg-$DEVNAME1 <<EOF
DEVICE=$DEVNAME1
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
MASTER=bond0
SLAVE=yes
EOF

cat > $NETDIR/ifcfg-$DEVNAME2 <<EOF
DEVICE=$DEVNAME2
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
MASTER=bond0
SLAVE=yes
EOF

#echo "ifenslave bond0 $DEVNAME1 $DEVNAME2" >> /etc/rc.d/rc.local
systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl restart network.service
exit 0

bash bound.sh #进行网卡绑定 
cat /proc/net/bonding/bond0
```
  ##  DevOps
  * [kjyw](https://gitee.com/aqztcom/kjyw) kjyw 快捷运维 目基于shell、python，运维脚本工具库，收集各类运维常用工具脚本，实现快速安装nginx、mysql、php、redis、nagios、运维经常使用的脚本等等
  * [shell]( git@github.com:zhouweiaccp/shell.git) shell 语法
  * [linux-network-performance-parameters](https://github.com/leandromoreira/linux-network-performance-parameters)
  * [the-book-of-secret-knowledge](https://github.com/trimstray/the-book-of-secret-knowledge) A collection of inspiring lists, manuals, cheatsheets, blogs, hacks, one-liners, cli/web 
tools and more.
 * [the-art-of-command-line](https://github.com/jlevy/the-art-of-command-line)本文是一份我在 Linux 上工作时，发现的一些命令行使用技巧的摘要。有些技巧非常基础，而另一些则相当复杂，甚至晦涩难懂。这篇文章并不长，但当你能够熟练掌握这里列出的所有技巧时
 * [growing-up](https://github.com/mylxsw/growing-up) 程序猿成长计划
 * [nux-tutorial](https://github.com/dunwu/linux-tutorial)Linux教程，主要内容：Linux 命令、Linux 系统运维、软件运维、精选常用Shell脚本
 * []()
