一、Python源代码编译安装
安装必要工具 yum-utils ，它的功能是管理repository及扩展包的工具 (主要是针对repository)

$ sudo yum install yum-utils
使用yum-builddep为Python3构建环境,安装缺失的软件依赖,使用下面的命令会自动处理.

$ sudo yum-builddep python
完成后下载Python3的源码包（笔者以Python3.5为例），Python源码包目录： https://www.python.org/ftp/python/ ，截至发博当日Python3的最新版本为 3.7.0

$ curl -O https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz
最后一步，编译安装Python3，默认的安装目录是 /usr/local 如果你要改成其他目录可以在编译(make)前使用 configure 命令后面追加参数 “–prefix=/alternative/path” 来完成修改。

$ tar xf Python-3.5.0.tgz
$ cd Python-3.5.0
$ ./configure
$ make
$ sudo make install
至此你已经在你的CentOS系统中成功安装了python3、pip3、setuptools，查看python版本

$ python3 -V
如果你要使用Python3作为python的默认版本，你需要修改一下 bashrc 文件，增加一行alias参数

alias python='/usr/local/bin/python3.5'
由于CentOS 7建议不要动/etc/bashrc文件，而是把用户自定义的配置放入/etc/profile.d/目录中，具体方法为

vi /etc/profile.d/python.sh
输入alias参数 alias python=’/usr/local/bin/python3.5’，保存退出

如果非root用户创建的文件需要注意设置权限

chmod 755 /etc/profile.d/python.sh
重启会话使配置生效

source /etc/profile.d/python.sh
二、从EPEL仓库安装
最新的EPEL 7仓库提供了Python3（python 3.4）的安装源，如果你使用CentOS7或更新的版本的系统你也可以按照下面的步骤很轻松的从EPEL仓库安装。

安装最新版本的EPEL

$ sudo yum install epel-release
用yum安装python 3.4:

$ sudo yum install python34
注意：上面的安装方法并未安装pip和setuptools，如果你要安装这两个库可以使用下面的命令：

$ curl -O https://bootstrap.pypa.io/get-pip.py
$ sudo /usr/bin/python3.4 get-pip.py
三、从SCL(Software Collections)仓库安装
最后一种方法是通过Software Collections (SCL) repository来安装，需要注意的是SCL仓库仅支持CentOS 6.5以上版本，最新版的SCL提供了Python3.3版本，具体安装步骤：

$ sudo yum install python33
从SCL中使用python3，你需要一行命令来启用Python3：

$ scl enable python33 <command>
您还可以使用Python编译器来调用一个bash shell:

$ scl enable python33 bash
https://www.centos.bz/2018/01/%E5%9C%A8centos%E4%B8%8A%E5%AE%89%E8%A3%85python3%E7%9A%84%E4%B8%89%E7%A7%8D%E6%96%B9%E6%B3%95/#二、从EPEL仓库安装
