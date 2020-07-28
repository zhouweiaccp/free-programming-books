## 常见问题
- [客户端ip](https://github.com/banianhost/remux/blob/master/app/nginx.conf#L57)  https://github.com/moby/moby/issues/32575  http://fengyilin.iteye.com/blog/2401156


## 常用命令
apt-get update 
apt install net-tools # ifconfig  netstat
apt install iputils-ping # ping
apt-get install inetutils-ping

 1查找docker的进程号 ：
docker inspect -f '{{.State.Pid}}' 49b98b2fbad2
2. 查看连接： 
nsenter -t 1840 -n netstat |grep ESTABLISHED


ceontos 安装 [https://www.cnblogs.com/linnuo/p/7159268.html]
yum install http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
cd /etc/yum.repos.d && wget http://www.hop5.in/yum/el6/hop5.repo
yum install docker-io
docker -h
6、启动docker
service docker start

7、停止docker
service docker stop



## docker 环境变量
printenv

## pouch
https://yq.aliyun.com/articles/272475

## docker 镜像地址
-[dockerhub](https://mirrors.ustc.edu.cn/help/dockerhub.html)


## docker book
- [Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/introduction/why.html) Docker — 从入门到实践