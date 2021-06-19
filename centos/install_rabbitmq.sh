#!/bin/bash


sudo yum install gcc glibc-devel make ncurses-devel openssl-devel autoconf
sudo yum install unixODBC unixODBC-devel
wget http://erlang.org/download/otp_src_20.3.tar.gz
cd otp_src_20.3
tar xvfz otp_src_20.3.tar.gz
./configure   
sudo make install
# 2 检查erlang是否安装成功

erl
# 3 安装RabbitMQ

wget https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.4/rabbitmq-server-generic-unix-3.7.4.tar.xz
xz -d rabbitmq-server-generic-unix-3.7.4.tar.xz 
tar -xvf rabbitmq-server-generic-unix-3.7.4.tar  
mv rabbitmq_server-3.7.4 /data/service/

4 添加环境变量

sudo vim /etc/profile ### 文件结尾追加

# rabbitmq
export RABBITMQ_HOME=/data/service/rabbitmq_server-3.7.4
export PATH=$RABBITMQ_HOME/sbin:$PATH
# 5 启动

rabbitmq-server -detached   #后台运行rabbitmq  
rabbitmq-plugins enable rabbitmq_management   #启动后台管理  
# 6 添加admin用户

# # 默认网页guest用户是不允许访问的，需要增加一个用户修改一下权限，代码如下：

rabbitmqctl add_user admin admin                               #添加用户
rabbitmqctl set_permissions -p "/" admin ".*" ".*" ".*"      #添加权限
rabbitmqctl set_user_tags admin administrator            #修改用户角色

# 作者：yanshaowen
# 链接：https://www.jianshu.com/p/e46e817cefe4
# 来源：简书
# 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。