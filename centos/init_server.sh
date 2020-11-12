#!/bin/bash
set -x
starttime=`date +'%Y-%m-%d %H:%M:%S'`
currentDate=`date "+%Y%m%d%H%M%S"`
cp  /etc/yum.repos.d/CentOS-Base.repo  /etc/yum.repos.d/CentOS-Base.repo_currentDate
curl http://mirrors.163.com/.help/CentOS6-Base-163.repo -o /etc/yum.repos.d/CentOS-Base.repo && yum clean all &&yum makecache
# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && yum clean all &&yum makecache

yum install -y zip unzip git tar wget  yum-utils 

##安装完成后生效，按下Tab键补全命令
yum install bash-completion -y

#显示时区
echo `date +%z`
#时间不同步
yum install -y ntp  && ntpdate ntp.aliyun.com
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && yum install -y docker-ce-18.03.1.ce &&systemctl start docker && systemctl enable docker

## Docker启动Get Permission Denied 
# sudo groupadd docker     #添加docker用户组
# sudo gpasswd -a $USER docker     #将登陆用户加入到docker用户组中
# newgrp docker     #更新用户组
# docker ps    #测试docker命令是否可以使用sudo正常使用

echo 'install netcore'
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm  && yum install -y dotnet-sdk-3.0

echo "install java"
#wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/otn/java/jdk/8u231-b11/5b13a193868b4bf28bcb45c792fce896/jdk-8u231-linux-x64.tar.gz"
wget https://repo.huaweicloud.com/java/jdk/8u201-b09/jdk-8u201-linux-x64.tar.gz
echo "install java download done"
mkdir -p /usr/java/
tar -zxvf jdk-8u201-linux-x64.tar.gz -C /usr/java/
rm jdk-8u201-linux-x64.tar.gz
# echo 'JAVA_HOME=/usr/java/jdk1.8.0_201' >> /etc/profile
# source /etc/profile
# echo "CLASSPATH=$JAVA_HOME/lib/" >> /etc/profile
# source /etc/profile
# echo "PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
# source /etc/profile
# echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile
# source /etc/profile

echo 'bak /etc/profile....'
cp /etc/profile /etc/profile$currentDate
sed -i '$aJAVA_HOME=/usr/java/jdk1.8.0_201'  /etc/profile
sed -i '$aCLASSPATH=$JAVA_HOME/lib/'  /etc/profile
sed -i '$aPATH=$PATH:$JAVA_HOME/bin'  /etc/profile
source /etc/profile

sed -i "\$a alias ll='ls -lth --time-style=\"+%Y-%m-%d %H:%M:%S\"'" ~/.bashrc # 转义单引号 双引号
 source ~/.bashrc
# echo "install node source"
# wget https://npm.taobao.org/mirrors/node/v11.0.0/node-v11.0.0.tar.gz
# tar -xvf node-v11.0.0.tar.gz
# cd node-v11.0.0
# yum install gcc gcc-c++
# ./configure
# make
# make install
# node -v


# npm install -g n
# n stable
#https://github.com/nodejs/help/wiki/Installation

##https://npm.taobao.org/mirrors/node/v14.15.0/node-v14.15.0.tar.gz
# https://nodejs.org/dist/v${nodever}/node-vv14.15.0-linux-arm64.tar.xz
nodever=14.15.0
echo "install node bin "
test ! -d /usr/local/lib/nodejs && mkdir -p /usr/local/lib/nodejs
if [ `arch` == 'aarch64' ]; then
wget https://nodejs.org/dist/v${nodever}/node-v${nodever}-linux-arm64.tar.xz
tar -xf node-v${nodever}-linux-arm64.tar.xz -C /usr/local/lib/nodejs
rm node-v${nodever}-linux-arm64.tar.xz
echo "export PATH=/usr/local/lib/nodejs/node-v${nodever}-linux-arm64/bin:$PATH" >> /etc/profile
else
wget https://nodejs.org/dist/v${nodever}/node-v${nodever}-linux-x64.tar.xz
tar -xJf node-v${nodever}-linux-x64.tar.xz -C /usr/local/lib/nodejs 
rm node-v${nodever}-linux-x64.tar.xz
echo "export PATH=/usr/local/lib/nodejs/node-v${nodever}-linux-x64/bin:$PATH" >> /etc/profile
fi

chmod 755 -R /usr/local/lib/nodejs
source /etc/profile

ln -s /usr/local/lib/nodejs/node-v${nodever}-linux-x64/bin/node /usr/bin/node
ln -s /usr/local/lib/nodejs/node-v${nodever}-linux-x64/bin/npm /usr/bin/npm
ln -s /usr/local/lib/nodejs/node-v${nodever}-linux-x64/bin/npx /usr/bin/npx
chmod -R 777 /usr/local/lib/nodejs/node-v${nodever}-linux-x64/

npm install -g cnpm --registry=https://registry.npm.taobao.org
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"

echo "python3"
./install_python3_code.sh
# yum install -y epel-release
# #yum -y install https://centos7.iuscommunity.org/ius-release.rpm
# #yum install -y python34
# #curl -O https://bootstrap.pypa.io/get-pip.py  /usr/bin/python3.4 get-pip.py
# yum -y install python36u
# yum -y install python36u-pip
# #使用python3去使用Python3.6：
# ln -s /usr/bin/python3.6 /usr/bin/python3
# #复制代码pip3.6同理：
# ln -s /usr/bin/pip3.6 /usr/bin/pip3

# test ! -d ~/pip && mkdir ~/.pip
# cat > ~/.pip/pip.conf<<efo
# [global]
# index-url = https://mirrors.aliyun.com/pypi/simple
# [install]
# trusted-host = https://pypi.tuna.tsinghua.edu.cn
# efo

# ./install_python3_code.sh  #source install python
echo "vim setting"
curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc

cat > etc/docker/daemon.json<<efo
{  "insecure-registries": ["https://192.168.75.12"]}
efo

echo 'Create new user ...https://github.com/zhouweiaccp/shell/base/ssh.sh'
for name in root1
do
 useradd -r -m -s /bin/bash $name
 echo "accp123" | passwd --stdin $name
# history –c
done

## chang ssh port 2202 ,root1 sudo
sed -i 's@#Port 22@Port 2202@g' /etc/ssd/sshd_config
/bin/systemctl restart sshd.service
echo 'root1   ALL=(ALL)       NOPASSWD: ALL' >>/etc/sudoers \


#执行程序
endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo "本次运行时间： "$((end_seconds-start_seconds))"s"