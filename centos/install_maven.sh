#!/bin/bash
dt=`date "+%Y%m%d%H%M%S"`
echo ${dt}
wget http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar zxvf apache-maven-3.3.9-bin.tar.gz
mv apache-maven-3.3.9/ maven3.3.9/
mv maven3.3.9/ /usr/local
cp /etc/profile /etc/profile_201912
sed -i '$a\MAVEN_HOME=/usr/local/maven3.3.9/' /etc/profile
echo 'PATH=$PATH:$MAVEN_HOME\/bin' >>/etc/profile
sed -i '$a\MAVEN_OPTS="-Xms256m -Xmx356m"' /etc/profile
sed -i '$a\export MAVEN_HOME' /etc/profile
sed -i '$a\export PATH' /etc/profile
sed -i '$a\export MAVEN_OPTS' /etc/profile
echo 'sed ...'
source /etc/profile
mvn -version


##source
mkdir -p /opt/maven-repository
cat > /usr/local/maven3.3.9/conf/settings.xml << eof
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <!--本地仓库位置-->
    <localRepository>/opt/maven-repository</localRepository>

    <pluginGroups>
    </pluginGroups>

    <proxies>
    </proxies>

    <!--设置 Nexus 认证信息-->
    <servers>
        <server>
            <id>nexus-releases</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
        <server>
            <id>nexus-snapshots</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
    </servers>

    <!--有自己的 nexus 改为自己的-->
    <mirrors>
        <mirror>
            <id>aliyun-releases</id>
            <mirrorOf>*</mirrorOf>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </mirror>
        <mirror>
            <id>aliyun-snapshots</id>
            <mirrorOf>*</mirrorOf>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        </mirror>
    </mirrors>

</settings>
eof

