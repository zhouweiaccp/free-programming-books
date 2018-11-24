sshd修改端口
vim /etc/ssh/sshd_config
 Port 22  改成  Port 2202
 /etc/init.d/ssh restart

.改变权限
 $ chmod a+w /etc/sudoers 
$ vi /etc/sudoers
# 然后添加 username 到 root 下，内容见下图
$ chmod a-w /etc/sudoers


更新ubuntu软件源
sudo apt-get update
sudo apt-get install -y python-software-properties software-properties-common
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
安装nodejs
sudo apt-get install nodejs
sudo apt install nodejs-legacy
sudo apt install npm
更新npm的包镜像源，方便快速下载
sudo npm config set registry https://registry.npm.taobao.org
sudo npm config list
全局安装n管理器(用于管理nodejs版本)
sudo npm install n -g
安装最新的nodejs（stable版本）
sudo n stable

wget http://cdn.npm.taobao.org/dist/node/v8.9.0/node-v8.9.0-linux-x64.tar.xz
1
解压 压缩包，node-v8.9.0-linux-x64.tar.xz
 tar xvJf node-v8.9.0-linux-x64.tar.xz
1
测试，进入bin目录输入 ./node -v 看看输出结果
./node -v
v8.9.0
1
2
修改环境变量
//输入指令
vi ~/.bashrc
//然后再最后面加入下面代码（路径根据自己解压的路径自行修改）
export PATH=/data/software/node-v8.9.0-linux-x64/bin:$PATH
//保存退出
//使之生效
source ~/.bashrc
测试效果,输入下面代码，看看结果
 node -v

常用软件
https://github.com/cjy37/linux-asp.net-installScript
 https://github.com/summerblue/laravel-ubuntu-init/blob/master/16.04/install.sh 
 https://github.com/licess/lnmp     
