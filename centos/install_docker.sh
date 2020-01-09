#!/bin/bash

#yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo && yum install -y docker-ce-18.03.1.ce &&systemctl start docker && systemctl enable docker

#https://www.cnblogs.com/yufeng218/p/8370670.html
yum remove docker  docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
if [ `arch` == 'aarch64' ]; then
wget  https://download.docker.com/linux/centos/7/aarch64/stable/Packages/docker-ce-cli-19.03.5-3.el7.aarch64.rpm
rpm -ivh docker-ce-cli-19.03.5-3.el7.aarch64.rpm
else
sudo yum install docker-ce docker-ce-cli containerd.io
fi


systemctl start docker
#yum erase docker-common-2:1.12.6-68.gitec8512b.el7.centos.x86_64
systemctl enable docker
docker version






## Docker启动Get Permission Denied 
sudo groupadd docker     #添加docker用户组
sudo gpasswd -a $USER docker     #将登陆用户加入到docker用户组中
newgrp docker     #更新用户组
docker ps    #测试docker命令是否可以使用sudo正常使用



#https://www.huaweicloud.com/kunpeng/software/docker.html
# 这个命令总是会安装最新版本的docker-ce，如果需要安装指定版本的可以参考下面的操作：

# sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io

# 方式二：下载软件包安装

# 1)     通过https://download.docker.com/linux/centos/7/aarch64/stable/Packages/，下载指定版本的软件包。

# 2)     执行命令安装软件包及依赖。


# “package.rpm”为下载的软件包。

# sudo yum install /path/to/package.rpm

# 3.      启动软件

# 1)     启动Docker。

# sudo systemctl start docker

# 2)     使用一个hello-world镜像验证Docker是否正常。

# sudo docker run hello-world

# 回显内容如下：

# Unable to find image 'hello-world:latest' locally
# latest: Pulling from library/hello-world
# 3b4173355427: Pull complete 
# Digest: sha256:41a65640635299bab090f783209c1e3a3f11934cf7756b09cb2f1e02147c6ed8
# Status: Downloaded newer image for hello-world:latest
 
# Hello from Docker!
# This message shows that your installation appears to be working correctly.
 
# To generate this message, Docker took the following steps:
#  1. The Docker client contacted the Docker daemon.
#  2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
#     (arm64v8)
#  3. The Docker daemon created a new container from that image which runs the
#     executable that produces the output you are currently reading.
#  4. The Docker daemon streamed that output to the Docker client, which sent it
#     to your terminal.
 
# To try something more ambitious, you can run an Ubuntu container with:
#  $ docker run -it ubuntu bash
 
# Share images, automate workflows, and more with a free Docker ID:
#  https://hub.docker.com/
 
# For more examples and ideas, visit:
#  https://docs.docker.com/get-started/