源码安装
wget https://npm.taobao.org/mirrors/node/v11.0.0/node-v11.0.0.tar.gz
tar -xvf node-v11.0.0.tar.gz
cd node-v11.0.0
sudo yum install gcc gcc-c++
./configure
make
sudo make install
node -v


方式一：直接安装

   一、安装

1.$ sudo apt-get install nodejs

2.$ sudo apt-get install npm

二、升级
    1.升级npm命令如下：

$ sudo npm install npm -g
/usr/local/bin/npm -> /usr/local/lib/node_modules/npm/bin/npm-cli.js
npm@2.14.2 /usr/local/lib/node_modules/npm
2.升级node.js命令如下：
$ npm install –g n
$ n latest(升级node.js到最新版)  or $ n stable（升级node.js到最新稳定版）
    n后面也可以跟随版本号比如：$ n v0.10.26 或者 $ n 0.10.26

三、npm镜像替换为淘宝镜像

 

1.得到原本的镜像地址

$ npm get registry 

> https://registry.npmjs.org/

设成淘宝的

$ npm config set registry http://registry.npm.taobao.org/

2.换成原来的

$ npm config set registry https://registry.npmjs.org/

 

四、选装cnpm

1.说明：因为npm安装插件是从国外服务器下载，受网络影响大，可能出现异常，如果npm的服务器在中国就好了，所以我们乐于分享的淘宝团队干了这事。！来自官网：“这是一个完整 npmjs.org 镜像，你可以用此代替官方版本(只读)，同步频率目前为 10分钟 一次以保证尽量与官方服务同步。”；

2.官方网址：http://npm.taobao.org；

3.安装：命令提示符执行npm install cnpm -g --registry=https://registry.npm.taobao.org；  注意：安装完后最好查看其版本号cnpm -v或关闭命令提示符重新打开，安装完直接使用有可能会出现错误；

注：cnpm跟npm用法完全一致，只是在执行命令时将npm改为cnpm（以下操作将以cnpm代替npm）

五、全局安装与本地安装
  npm 的包安装分为本地安装（local）、全局安装（global）两种，从敲的命令行来看，差别只是有没有-g而已，

   比如我们使用 npm 命令安装常用的 Node.js web框架模块 express:

$ npm install express          # 本地安装
$ npm install express -g       # 全局安装

六、卸载
1.先卸载 npm 
  sudo npm uninstall npm -g
2.卸载nodejs
  sudo apt-get remove nodejs
方式二：nvm安装
安装
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
使用
安装成功后,需要关闭xshell，重新启动。nvm才会生效。

使用command -v nvm查看nvm是否安装成功

root@linuxidc:~# command -v nvm
nvm
查看已安装
通过nvm ls查看已安装的版本

$ nvm ls
            N/A
node -> stable (-> N/A) (default)
iojs -> N/A (default)
查看有哪些可安装
通过nvm ls-remote查看可使用版本

$ nvm ls-remote
        v0.1.14
        v0.1.15
        v0.1.16
        v0.1.17
        v0.1.18
...
安装nodejs
通过nvm install 7.8.0来安装，后面的版本号我们可以任意选择

root@linuxidc:~# nvm install 7.8.0
Downloading and installing node v6.2.0...
Downloading https://nodejs.org/dist/v7.8.0/node-v7.8.0-linux-x64.tar.xz...
我们上面使用的是国外的服务器下载，很慢，耐心等待，nodejs和nvm成功安装！

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

 ---------
 1. sudo cp -r node-v0.10.28  /usr/local/node

2. sudo vi /etc/profile.d/node.sh

3.node.sh文件内容：
export NODE_HOME=/usr/local/node 
export PATH=$NODE_HOME/bin:$PATH

 4. 重启电脑
ln -s /usr/local/node/bin/node /usr/bin/node
ln -s /usr/local/node/bin/npm /usr/bin/npm