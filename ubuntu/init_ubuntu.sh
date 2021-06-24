#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# Blog:  http://blog.linuxeye.com https://gitee.com/aqztcom/kjyw/blob/master/linux-init-script/init_Ubuntu.sh


if [ -f /etc/redhat-release ];then
        OS=CentOS
elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS=Debian
elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS=Ubuntu
else
        echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
        kill -9 $$
fi

OS_command()
{
	if [ $OS == 'CentOS' ];then
	        echo -e $OS_CentOS | bash
	elif [ $OS == 'Debian' -o $OS == 'Ubuntu' ];then
		echo -e $OS_Debian_Ubuntu | bash
	else
		echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
		kill -9 $$
	fi
}

## aliyun.com chang port
sed -ir 's/^#Port.*/Port 2202/' /etc/ssh/sshd_config
/etc/init.d/ssh start
service ssh --full-restart


# https://github.com/pythonchannel/wechat-spider/blob/6aa10c327a2dff58b5e4268d63316b8eaffbf833/Dockerfile
cat /etc/apt/sources.list | awk -F[/:] '{print $4}' | sort | uniq | grep -v "^$" | xargs -I{} sed -i 's|{}|mirrors.aliyun.com|g' /etc/apt/sources.list && apt update && apt-get clean 
#rm -rf /var/lib/apt/lists/*
for Package in apache2 apache2-doc apache2-utils apache2.2-common apache2.2-bin apache2-mpm-prefork apache2-doc apache2-mpm-worker mysql-client mysql-server mysql-common php5 php5-common php5-cgi php5-mysql php5-curl php5-gd libmysql* mysql-*
do
	apt-get -y remove $Package 
done
dpkg -l | grep ^rc | awk '{print $2}' | xargs dpkg -P

apt-get -y update

# check upgrade OS
[ "$upgrade_yn" == 'y' ] && apt-get -y upgrade 

# Install needed packages
for Package in gcc g++ make autoconf libjpeg8 libjpeg8-dev libpng12-0 libpng12-dev libpng3 libfreetype6 libfreetype6-dev libxml2 libxml2-dev zlib1g zlib1g-dev libc6 libc6-dev libglib2.0-0 libglib2.0-dev bzip2 libzip-dev libbz2-1.0 libncurses5 libncurses5-dev curl libcurl3 libcurl4-openssl-dev e2fsprogs libkrb5-3 libkrb5-dev libltdl-dev libidn11 libidn11-dev openssl libtool libevent-dev bison libsasl2-dev libxslt1-dev patch vim zip unzip tmux htop wget bc expect rsync
do
	apt-get -y install $Package
done

if [ ! -z "`cat /etc/issue | grep 13`" ];then
       apt-get -y install libcloog-ppl1
elif [ ! -z "`cat /etc/issue | grep 12`" ];then
       apt-get -y install libcloog-ppl0
fi

# check sendmail
[ "$sendmail_yn" == 'y' ] && apt-get -y install sendmail

# PS1
[ -z "`cat ~/.bashrc | grep ^PS1`" ] && echo "PS1='\${debian_chroot:+(\$debian_chroot)}\\[\\e[1;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '" >> ~/.bashrc 

# history size 
sed -i 's/HISTSIZE=.*$/HISTSIZE=100/g' ~/.bashrc 
[ -z "`cat ~/.bashrc | grep history-timestamp`" ] && echo "export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });user=\$(whoami); echo \$(date \"+%Y-%m-%d %H:%M:%S\"):\$user:\`pwd\`/:\$msg ---- \$(who am i); } >> /tmp/\`hostname\`.\`whoami\`.history-timestamp'" >> ~/.bashrc

# /etc/security/limits.conf
[ -z "`cat /etc/security/limits.conf | grep 'nproc 65535'`" ] && cat >> /etc/security/limits.conf <<EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
[ -z "`cat /etc/rc.local | grep 'ulimit -SH 65535'`" ] && echo "ulimit -SH 65535" >> /etc/rc.local

# /etc/hosts
[ "$(hostname -i | awk '{print $1}')" != "127.0.0.1" ] && sed -i "s@^127.0.0.1\(.*\)@127.0.0.1   `hostname` \1@" /etc/hosts

# Set timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Set DNS
#cat > /etc/resolv.conf << EOF
#nameserver 114.114.114.114
#nameserver 8.8.8.8
#EOF

# alias vi
[ -z "`cat ~/.bashrc | grep 'alias vi='`" ] && sed -i "s@^alias l=\(.*\)@alias l=\1\nalias vi='vim'@" ~/.bashrc

# /etc/sysctl.conf
[ -z "`cat /etc/sysctl.conf | grep 'fs.file-max'`" ] && cat >> /etc/sysctl.conf << EOF
fs.file-max=65535
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30 
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 65535 
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 262144
EOF
sysctl -p

sed -i 's@^ACTIVE_CONSOLES.*@ACTIVE_CONSOLES="/dev/tty[1-2]"@' /etc/default/console-setup 
sed -i 's@^@#@g' /etc/init/tty[3-6].conf
echo 'en_US.UTF-8 UTF-8' > /var/lib/locales/supported.d/local
sed -i 's@^@#@g' /etc/init/control-alt-delete.conf 

# Update time
# ntpdate pool.ntp.org 
# echo "*/20 * * * * `which ntpdate` pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/crontabs/root;chmod 600 /var/spool/cron/crontabs/root 
# service cron restart

# iptables
# cat > /etc/iptables.up.rules << EOF
# # Firewall configuration written by system-config-securitylevel
# # Manual customization of this file is not recommended.
# *filter
# :INPUT DROP [0:0]
# :FORWARD ACCEPT [0:0]
# :OUTPUT ACCEPT [0:0]
# :syn-flood - [0:0]
# -A INPUT -i lo -j ACCEPT
# -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
# -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
# -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
# -A INPUT -p icmp -m limit --limit 100/sec --limit-burst 100 -j ACCEPT
# -A INPUT -p icmp -m limit --limit 1/s --limit-burst 10 -j ACCEPT
# -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn-flood
# -A INPUT -j REJECT --reject-with icmp-host-prohibited
# -A syn-flood -p tcp -m limit --limit 3/sec --limit-burst 6 -j RETURN
# -A syn-flood -j REJECT --reject-with icmp-port-unreachable
# COMMIT
# EOF
# iptables-restore < /etc/iptables.up.rules
# echo 'pre-up iptables-restore < /etc/iptables.up.rules' >> /etc/network/interfaces

#sqlite
apt-get install sqlite  -y
apt-get install libsqlite3-dev -y

## nodejs
 apt-get install npm nodejs -y

#  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
#  source ~/.nvm/nvm.sh
#  nvm install node 

# wget https://nodejs.org/dist/v12.18.1/node-v12.18.1-linux-x64.tar.xz    // 下载
# tar xf node-v12.18.1-linux-x64.tar.xz                                   // 解压
# cd node-v12.18.1-linux-x64                                              // 进入解压目录
# cp /etc/profile /etc/profile.bak
# export PATH=$PATH:/root/node-v12.18.1-linux-x64/bin
# source /etc/profile

# docker 离线
#wget https://download.docker.com/linux/ubuntu/dists/$(lsb_release -cs)/pool/stable/amd64/

# ubuntu20.demo
# https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_20.10.7~3-0~ubuntu-focal_amd64.deb
# https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_20.10.7~3-0~ubuntu-focal_amd64.deb
# https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_1.4.6-1_amd64.deb
# https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/
# 1、下载离线包，网址：https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/
#      离线安装docker需要下载3个包，containerd.io ，docker-ce-cli，docker-ce
# 2、下载完毕后拷贝到ubuntu上用 dpkg 命令安装，先安装 containerd.io 跟 docker-ce-cli，最后安装docker-ce，命令
#    sudo dpkg -i xxxx.deb