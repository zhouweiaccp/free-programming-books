#!/bin/bash
cd /etc/yum.repos.d
mv ./CentOS-Base.repo ./CentOS-Base-repo.bak
yum clean all &&yum makecache
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
yum install -y zip unzip git tar wget
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && yum install -y docker-ce-18.03.1.ce &&systemctl start docker && systemctl enable docker
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm  && yum install -y dotnet-sdk-2.2
echo "install java"
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
echo "install java download done"
mkdir -p /usr/java/jdk1.8.0_141
tar -zxvf jdk-8u141-linux-x64.tar.gz -C /usr/java/jdk1.8.0_141
echo 'JAVA_HOME=/usr/java/jdk1.8.0_141' >> /etc/profile
echo "CLASSPATH=$JAVA_HOME/lib/" >> /etc/profile
echo "PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile
source /etc/profile
java version
