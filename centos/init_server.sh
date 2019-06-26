#!bin/bash
yum install -y zip unzip git
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && yum install -y docker-ce-18.03.1.ce &&systemctl start docker && systemctl enable docker
rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm && yum update && yum install -y dotnet-sdk-2.2
echo "install java"
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
echo "install java download done"
mkdir -p /usr/java
tar -zxvf jdk-8u141-linux-x64.tar.gz -C /usr/java/jdk1.8.0_141
echo 'JAVA_HOME=/usr/java/jdk1.8.0_141' >>vim /etc/profile
echo "CLASSPATH=$JAVA_HOME/lib/" >>vim /etc/profile
echo "PATH=$PATH:$JAVA_HOME/bin" >>vim /etc/profile
echo "export PATH JAVA_HOME CLASSPATH" >>vim /etc/profile
source /etc/profile
java