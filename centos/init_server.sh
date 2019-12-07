#!/bin/bash
# cd /etc/yum.repos.d
# mv ./CentOS-Base.repo ./CentOS-Base-repo.bak
mv /etc/yum.repos.d/CentOS-Base.repo{,_bak} && wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O /etc/yum.repos.d/CentOS-Base.repo && yum clean all &&yum makecache
# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install -y zip unzip git tar wget
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && yum install -y docker-ce-18.03.1.ce &&systemctl start docker && systemctl enable docker
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm  && yum install -y dotnet-sdk-2.2
echo "install java"
#wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/otn/java/jdk/8u231-b11/5b13a193868b4bf28bcb45c792fce896/jdk-8u231-linux-x64.tar.gz"
wget https://repo.huaweicloud.com/java/jdk/8u201-b09/jdk-8u201-linux-x64.tar.gz
echo "install java download done"
mkdir -p /usr/java/
tar -zxvf jdk-8u201-linux-x64.tar.gz -C /usr/java/
rm jdk-8u201-linux-x64.tar.gz
echo 'JAVA_HOME=/usr/java/jdk1.8.0_201' >> /etc/profile
echo "CLASSPATH=$JAVA_HOME/lib/" >> /etc/profile
echo "PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile
source /etc/profile

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
echo "install node bin"
wget https://nodejs.org/dist/v10.16.0/node-v10.16.0-linux-x64.tar.xz
mkdir -p /usr/local/lib/nodejs
tar -xJf node-v10.16.0-linux-x64.tar.xz -C /usr/local/lib/nodejs 
rm node-v10.16.0-linux-x64.tar.xz
echo "export PATH=/usr/local/lib/nodejs/node-v10.16.0-linux-x64/bin:$PATH" >> /etc/profile
source /etc/profile

ln -s /usr/local/lib/nodejs/node-v10.16.0-linux-x64/bin/node /usr/bin/node
ln -s /usr/local/lib/nodejs/node-v10.16.0-linux-x64/bin/npm /usr/bin/npm
ln -s /usr/local/lib/nodejs/node-v10.16.0-linux-x64/bin/npx /usr/bin/npx

npm install -g cnpm --registry=https://registry.npm.taobao.org
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"

echo "python3"
yum install -y epel-release
yum install -y python34
curl -O https://bootstrap.pypa.io/get-pip.py
/usr/bin/python3.4 get-pip.py

mkdir ~/.pip
cat > ~/.pip/pip.conf<<efo
[global]
index-url = https://mirrors.aliyun.com/pypi/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
efo


echo "vim setting"
curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc
