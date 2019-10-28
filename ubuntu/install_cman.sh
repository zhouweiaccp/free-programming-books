#!/bin/bash

#1、先安装所需要的依赖包：

#automake 工具

sudo apt-get install -y autoconf automake libtool

#git 工具

#sudo apt-get install git 

#2、下载中文man安装包:

sudo mkdir /usr/local/zhman

cd /usr/local/zhman

git clone https://github.com/lidaobing/manpages-zh.git
#git clone git@github.com:lidaobing/manpages-zh.git 

#3、安装操作步骤如下:

cd manpages-zh

sh autogen.sh

sudo ./configure --prefix=/usr/local/zhman --disable-zhtw         

sudo make

sudo make install

#4、配置环境：

cd ~

#sudo gedit .bashrc
cp .bashrc .bashrc_bak
sed -i '$aalias cman='\''man -M \/usr\/local\/zhman\/share\/man\/zh_CN@@' .bashrc
sed -i "s/@@/'/g" .bashrc
#  sed -i '$aalias cman='\''man -M \/usr\/local\/zhman\/share\/man\/zh_CN@@' ho
#最后需要加单引号
#5、在.bashrc最后一行增加:

# alias cman='man -M /usr/local/zhman/share/man/zh_CN'  保存退出。

#6、执行命令:

source .bashrc
