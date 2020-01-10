
#!/bin/bash
#  经过华为云严格实测，以下操作系统在鲲鹏生态中可以完整运行MySQL服务的全部功能：

# −           CentOS7.5

# −           Euler 2.8  https://www.huaweicloud.com/kunpeng/software/mysql.html

# 支持版本和获取方式

# l   MySQL 5.6

# 编译和测试方式

# 本文选用华为鲲鹏云服务ECS KC1实例做测试，KC1实例的处理器为兼容ARMv8指令集的鲲鹏920，支持2核/4核。

# 1.      操作系统选择

# 使用的操作系统为Euler 2.8，内核版本号为：4.19.36。

# 2.      获取源代码

# github上（https://github.com/mysql/mysql-server）提供mysql社区版的源代码压缩包，可以直接下载，各版本的列表可以通过：

# https://github.com/mysql/mysql-server/releases获取

# 3.      编译环境配置

# l   安装依赖包：

yum install gcc gcc-c++ make cmake libaio-devel openssl-devel zlib-devel ncurses-devel bison -y

# l   下载解压boost：

mkdir /usr/local/src/boost && cd  /usr/local/src/boost

wget -c https://kent.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz --no-check-certificate
tar -zxvf boost_1_59_0.tar.gz

# 4.      编译源代码

# l   下载mysql-5.6.44源码并解压：

mkdir /usr/local/src/mysql && cd  /usr/local/src/mysql

wget -c https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.44.tar.gz
tar -zxvf mysql-5.6.44.tar.gz

# l   进入MySQL解压目录，建立编译目录并进入编译目录：

cd /usr/local/src/mysql/mysql-5.6.44 && mkdir build && cd build

# l   配置：

mkdir /usr/local/mysql

cmake /usr/local/src/mysql/mysql-5.6.44  -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DWITH_BOOST=/usr/local/src/boost/boost_1_59_0

# 编译安装：

make
make install

# 5.      测试已完成编译的软件

# l   版本检查。如果安装成功，会正确显示版本。

/usr/local/mysql/bin/mysql --version