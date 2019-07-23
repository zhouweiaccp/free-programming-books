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

常用软件
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