
yum -y groupinstall "Development tools"
yum -y install gcc glibc make 
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
yum install libffi-devel -y
#2.下载安装包解压
cd #回到用户目录
wget http://npm.taobao.org/mirrors/python/3.7.0/Python-3.7.0.tgz
tar -Jxvf Python-3.7.0.tgz
#3.编译安装
mkdir /usr/local/python3 #创建编译安装目录
cd Python-3.7.0
./configure --prefix=/usr/local/python3
make && make install
#4.创建软连接
ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/local/bin/pip3

pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/