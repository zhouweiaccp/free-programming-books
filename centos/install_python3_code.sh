
yum -y groupinstall "Development tools"
yum -y install gcc glibc make 
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
yum install libffi-devel -y
#2.下载安装包解压
cd #回到用户目录
#wget http://npm.taobao.org/mirrors/python/3.7.0/Python-3.7.0.tgz
#tar -xvf Python-3.7.0.tgz
#cd Python-3.7.0
# scrapy 版本问题
wget https://npm.taobao.org/mirrors/python/3.4.9/Python-3.4.9.tgz
tar -xvf Python-3.4.9.tgz
#3.编译安装
test ! -d /usr/local/python3 && mkdir /usr/local/python3 #创建编译安装目录
cd Python-3.4.9
./configure --prefix=/usr/local/python3
make && make install
#4.创建软连接
ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/local/bin/pip3

test ! -d ~/pip && mkdir ~/.pip
cat > ~/.pip/pip.conf<<efo
[global]
index-url = https://mirrors.aliyun.com/pypi/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
efo

pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/

wget https://twistedmatrix.com/Releases/Twisted/19.10/Twisted-19.10.0.tar.bz2
tar -xjf Twisted-19.10.0.tar.bz2
cd Twisted-19.10.0
python3  setup.py install
pip3 install scrapy --user


# gcc  安装过程
#  wget https://obs-mirror-ftp4.obs.cn-north-4.myhuaweicloud.com/genome-software/gcc-9.2.0.tar.gz
#  tar -C /opt/software/ -zxf gcc-9.2.0.tar.gz
#  cd /opt/software/gcc-9.2.0/
#   yum install -y *lbzip2*
#  ./contrib/download_prerequisites
# mkdir build
# cd build/
# ../configure --enable-checking=release --enable-languages=c,c++ --disable-multilib
# make
# make install
# cp /usr/local/bin/* /usr/bin/
# gcc --version
# g++ --version
# pip install --upgrade pip  -i http://pypi.douban.com/simple/

# yum install -y epel-release 

# yum install -y openldap-devel 

# yum install -y python-devel 

# yum install -y python-pip

# pip install --upgrade pip