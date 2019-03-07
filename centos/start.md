mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo_bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum makecache
yum -y update
yum install -y dos2unix
yum install -y unzip zip


java
 yum -y install java-1.8.0-openjdk*


wget http://www.rarsoft.com/rar/rarlinux-5.3.0.tar.gz
tar -zxvf rarlinux-5.3.0.tar.gz
cd rar
rar软件不需要安装，直接解压到/usr/local下，以下操作需要有root权限。
https://blog.csdn.net/wanda3086/article/details/50571417
ln -s /usr/local/rar/rar /usr/local/bin/rar
ln -s /usr/local/rar/unrar /usr/local/bin/unrar

