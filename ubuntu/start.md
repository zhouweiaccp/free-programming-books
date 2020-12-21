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
 
  ##  DevOps
  * [kjyw](https://gitee.com/aqztcom/kjyw) kjyw 快捷运维 目基于shell、python，运维脚本工具库，收集各类运维常用工具脚本，实现快速安装nginx、mysql、php、redis、nagios、运维经常使用的脚本等等
  * [shell]( git@github.com:zhouweiaccp/shell.git) shell 语法
  * [linux-network-performance-parameters](https://github.com/leandromoreira/linux-network-performance-parameters)
  * [the-book-of-secret-knowledge](https://github.com/trimstray/the-book-of-secret-knowledge) A collection of inspiring lists, manuals, cheatsheets, blogs, hacks, one-liners, cli/web 
tools and more.
 * [the-art-of-command-line](https://github.com/jlevy/the-art-of-command-line)本文是一份我在 Linux 上工作时，发现的一些命令行使用技巧的摘要。有些技巧非常基础，而另一些则相当复杂，甚至晦涩难懂。这篇文章并不长，但当你能够熟练掌握这里列出的所有技巧时
 * [growing-up](https://github.com/mylxsw/growing-up) 程序猿成长计划
 * []()
 * []()
